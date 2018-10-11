classdef IntegralUnit < FunctionSpace.FEM.QueryUnit
    %INTEGRALUINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        integral_element_
        integral_element_node_
        gauss_quadrature_
    end
    
    methods
        function this = IntegralUnit(patch_element_id)
            this@FunctionSpace.FEM.QueryUnit(patch_element_id);
        end
    end
end

