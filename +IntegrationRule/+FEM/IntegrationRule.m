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
                int_unit.quadrature_ = ...
                    GaussQuadrature.MappingElementType2GaussQuadrature(...
                                                            element_type);
                % int_unit add into container
                this.integral_unit_{int_ele_id} = int_unit;
            end    
            status = true;
        end
        
        function status = generateBoundaryIntUnit(this, generate_parameter)
            status = true;
        end
    end
end

