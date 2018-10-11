classdef IntegrationRule < IntegrationRule.IntegrationRuleBase
    %INTEGRATIONRULE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_
        region_
    end
    
    methods
        function this = IntegrationRule(patch)
            this@IntegrationRule.IntegrationRuleBase(patch)
            this.region_ = patch.patch_region_;
            this.type_ = patch.patch_type_;
            this.generateFEM_IntegrationRule();
        end
    end
    
    methods (Access = private)
        generateFEM_IntegrationRule(this)
    end
    
end

