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
            status = true;
        end
    end
    
end

