classdef BoundaryDomain < handle
    %BOUNDARYDOMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        function_space_
        intergation_rule_
    end
    
    methods
        function this = BoundaryDomain(patch)
            import FunctionSpace.FEM.*
            this.function_space_ = FunctionSpace(patch);
        end
        
        function setIntergationRule(this, patch)
            import IntegrationRule.FEM.*
            this.intergation_rule_ = IntegrationRule(patch);
        end
    end
    
end

