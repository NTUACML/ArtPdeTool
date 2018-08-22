classdef IntegrationRuleBase < handle
    %INTEGRATIONRULEBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_data_
        num_integral_unit_ = 0
        integral_unit_data_
    end
    
    methods
        function this = IntegrationRuleBase(patch)
            this.patch_data_ = patch;
        end
    end
    
end

