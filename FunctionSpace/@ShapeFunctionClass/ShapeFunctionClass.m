classdef ShapeFunctionClass
    %SHAPEFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        [shape_func, d_shape_func] = Hexa8(xi)
        [shape_func, d_shape_func] = Line2(xi)
    end
    
end

