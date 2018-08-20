classdef InteriorDomain < handle
    %INTERIORDOMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        function_space_
        intergation_rule_
    end
    
    methods
        function this = InteriorDomain()
            import FunctionSpace.FEM.*
            import IntegrationRule.FEM.*
            this.function_space_ = FunctionSpace();
            this.intergation_rule_ = IntegrationRule();
        end
    end
    
end

