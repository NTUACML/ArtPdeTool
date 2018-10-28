classdef ExpressionBase < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = ExpressionBase()
        end
    end
    
    methods(Abstract)
        [type, var, basis_id, data] = eval(this, query_unit);
    end
    
end

