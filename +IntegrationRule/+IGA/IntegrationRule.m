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
            % IntUnit number
            this.num_integral_unit_ = this.integral_patch_.num_element_;
            % creat IntUnit
            this.integral_unit_ = cell(this.num_integral_unit_, 1);
            % generate IntUnit
            import IntegrationRule.FEM.IntegralUnit
            import IntegrationRule.FEM.GaussQuadrature
            for int_ele_id = 1 : this.num_integral_unit_
                % new IntUnit
                int_element_data = this.integral_patch_.element_data_{int_ele_id};
                int_unit = IntegralUnit(this.integral_patch_.region_,...
                    int_ele_id, int_element_data);
                
                
                % add guass quadrature data
                element_type = int_element_data.element_type_;
                boundary_quadrature = ...
                    GaussQuadrature.MappingElementType2GaussQuadrature(...
                    element_type);
                % modify quadrature rule
                int_unit.quadrature_ = this.modifiedQuadPoint(boundary_quadrature, int_element_data);
                
                % int_unit add into container
                this.integral_unit_{int_ele_id} = int_unit;
            end
            status = true;
        end    
        
        function quadrature = modifiedQuadPoint(this, boundary_quadrature, int_element_data)
            neighbor_element_data = int_element_data.neighbor_element_data_;
                     
            import Utility.MeshUtility.ElementType
            switch neighbor_element_data.element_type_
                case ElementType.Hexa8
                    quadrature = @() this.toHexa8Coordinate(boundary_quadrature, int_element_data);
                otherwise
                    disp('The import neighbor element type is not supported!');
            end   
            
            [num_quadrature, position, weighting] = quadrature();
        end
        
        function [num_quadrature, position, weighting] = toHexa8Coordinate(this, boundary_quadrature, int_element_data)
            [num_quadrature, position, weighting] = boundary_quadrature();
            switch int_element_data.orientation_.which_boundary_id_
                case 1 % zeta = -1
                    position = [position, -ones(num_quadrature,1)];
                case 2 % zeta = 1
                    position = [position, ones(num_quadrature,1)];
                case 3 % xi = -1
                    position = [-ones(num_quadrature,1), position];
                case 4 % xi = 1
                    position = [ones(num_quadrature,1), position];
                case 5 % eta = -1
                    position = [position(:,1), -ones(num_quadrature,1), position(:,2)];
                case 6 % eta = 1
                    position = [position(:,1), ones(num_quadrature,1), position(:,2)];
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
                    for i = 1:nume_element(1)
                        uniqued_knots(i:i+1)
                        element_span = {uniqued_knots(i:i+1)};
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

