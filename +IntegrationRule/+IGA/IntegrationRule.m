classdef IntegrationRule < IntegrationRule.IntegrationRuleBase
    %INTEGRATIONRULE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = IntegrationRule(patch, expression)
            this@IntegrationRule.IntegrationRuleBase(patch, expression);
        end
        
        function status = generate(this, generate_parameter)
            import Utility.BasicUtility.Region
            if(this.integral_patch_.region_ == Region.Domain)
                status = this.generateDomainIntUnit(generate_parameter);
            elseif(this.integral_patch_.region_ == Region.Boundary)
                status = this.generateBoundaryIntUnit(generate_parameter);
            else
                disp('Error <IntegrationRule>! - generate!');
                disp('> Your integral region is wrong! please check it~');
                status = false;
            end
        end
    end
    
    methods(Access = private)
        function status = generateDomainIntUnit(this, generate_parameter)
            nurbs_data = this.integral_patch_.nurbs_data_;  
            if isempty(generate_parameter)
                dividing_method = 'Default';
                number_quad_pnt = ceil((nurbs_data.order_ + 1)*0.5);  
            else
                dividing_method = generate_parameter{1};
                number_quad_pnt = generate_parameter{2};
            end
            
            % IntUnit number
            switch dividing_method
                case 'Default'
                    % note: this.integral_unit_ is allocated inside
                    % generateKnotVectorMesh. Consider to modify
                    this.generateIntegralUnitByKnotMesh(nurbs_data);
                case 'QuadTree'
                    disp('To be finihed...');
                    %nurbs_mesh = this.generateIntegralUnitByQuadTree(some_stratergy);
            end
            
            
            % generate quadrature rule
            import IntegrationRule.IGA.GaussQuadrature
            for int_unit_id = 1 : this.num_integral_unit_
                % add guass quadrature data
                this.integral_unit_{int_unit_id}.quadrature_ = ...
                    GaussQuadrature.MappingNurbsType2GaussQuadrature(...
                    nurbs_data.type_, this.integral_unit_{int_unit_id}.unit_span_, number_quad_pnt);
                
            end
            status = true;
        end
        
        function status = generateBoundaryIntUnit(this, generate_parameter)
            nurbs_data = this.integral_patch_.nurbs_data_;  
            if isempty(generate_parameter)
                dividing_method = 'Default';
                number_quad_pnt = ceil((nurbs_data.order_ + 1)*0.5);  
            else
                dividing_method = generate_parameter{1};
                number_quad_pnt = generate_parameter{2};
            end
            
            % IntUnit number
            switch dividing_method
                case 'Default'
                    % note: this.integral_unit_ is allocated inside
                    % generateKnotVectorMesh. Consider to modify
                    this.generateIntegralUnitByKnotMesh(nurbs_data);
                case 'QuadTree'
                    disp('To be finihed...');
                    %nurbs_mesh = this.generateIntegralUnitByQuadTree(some_stratergy);
            end
            
            
            % generate quadrature rule
            import IntegrationRule.IGA.GaussQuadrature
            for int_unit_id = 1 : this.num_integral_unit_
                % add guass quadrature data
                integral_unit = this.integral_unit_{int_unit_id};
                integral_unit.quadrature_ = ...
                    GaussQuadrature.MappingNurbsType2GaussQuadrature(...
                    nurbs_data.type_, this.integral_unit_{int_unit_id}.unit_span_, number_quad_pnt);
                % map to domain nurbs parametric coordinates
                integral_unit.quadrature_{2} = nurbs_data.evaluateNurbs(integral_unit.quadrature_{2});
                
                if length(nurbs_data.knot_vectors_) == 1
                    integral_unit.quadrature_{2} = integral_unit.quadrature_{2}(:,1:2);
                end
                % modify weightings
                % TODO suuport NURBS solid
                le = norm(nurbs_data.control_points_(nurbs_data.control_points_.num_rows_,1:3)-nurbs_data.control_points_(1,1:3));
                integral_unit.quadrature_{3} = integral_unit.quadrature_{3}*le;
                
            end
            status = true;
        end    
        
        function modifiedQuadPoint(this, integral_unit, nurbs_data)
            import Utility.NurbsUtility.NurbsType
            switch nurbs_data.type_
                case NurbsType.Curve
                    xi = nurbs_data.parametric_mapping_{1};
                    eta = nurbs_data.parametric_mapping_{2};
                    u = integral_unit.quadrature_{2};
                    
                    if length(xi) == 2
                        le = xi(2)-xi(1);
                        xi = xi(1)+ le*u;              
                        integral_unit.quadrature_{2} = [xi eta*ones(size(xi))];
                        integral_unit.quadrature_{3} = integral_unit.quadrature_{3}* le;
                    else
                        le = eta(2)-eta(1);
                        eta = eta(1)+ le*u;              
                        integral_unit.quadrature_{2} = [xi*ones(size(eta)) eta];
                        integral_unit.quadrature_{3} = integral_unit.quadrature_{3}* le;
                    end 
                case NurbsType.Surface
                
                otherwise   
                    disp('input boundary nurbs should be either Curve or Surface!');
            end
        end
        
        
        function generateIntegralUnitByKnotMesh(this,nurbs_data)
            import IntegrationRule.IGA.IntegralUnit
            
            uniqued_knots = nurbs_data.knot_vectors_;
            for i = 1:length(uniqued_knots)
                uniqued_knots{i} = unique(uniqued_knots{i});
            end
            
            dimension = length(uniqued_knots);
            num_element = ones(1, dimension);
            for i = 1:dimension
                num_element(i) = size(uniqued_knots{i},2)-1;
            end
            
            % create integration unit container
            this.num_integral_unit_ = prod(num_element);
            this.integral_unit_ = cell(this.num_integral_unit_, 1);
            
            switch dimension
                case 1
                    for i = 1:num_element(1)
                        element_span = {uniqued_knots{1}(i:i+1)};
                        % new integral unit
                        int_unit = IntegralUnit(this.integral_patch_.region_, element_span);
                        this.integral_unit_{i} = int_unit;
                    end
                case 2
                    for i = 1:num_element(1)
                        for j = 1:num_element(2)
                            n = (i-1)*num_element(2) + j;
                            element_span = {uniqued_knots{1}(i:i+1), uniqued_knots{2}(j:j+1)};
                            % new integral unit
                            int_unit = IntegralUnit(this.integral_patch_.region_, element_span);
                            this.integral_unit_{n} = int_unit;
                        end
                    end
                case 3
                    for i = 1:num_element(1)
                        for j = 1:num_element(2)
                            for k = 1:num_element(3)
                                n = (i-1)*num_element(2)*num_element(3) + (j-1)*num_element(3) + k;
                                element_span = {uniqued_knots{1}(i:i+1), uniqued_knots{2}(j:j+1), uniqued_knots{3}(k:k+1)};
                                % new integral unit
                                int_unit = IntegralUnit(this.integral_patch_.region_, element_span);
                                this.integral_unit_{n} = int_unit;
                            end
                        end
                    end
            end % end switch
        end
        
    end
end

