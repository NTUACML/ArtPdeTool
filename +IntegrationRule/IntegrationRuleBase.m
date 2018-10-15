classdef IntegrationRuleBase < handle
    %INTEGRATIONRULEBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        integral_patch_
        expression_
        num_integral_unit_ = 0
        integral_unit_
    end
    
    methods
        function this = IntegrationRuleBase(patch, expression)
            this.integral_patch_ = patch;
            this.expression_ = expression;
        end
    end
    
    methods (Abstract)
        status = generate(this, generate_parameter);
    end
    
end

