classdef ShapeFunction
    %SHAPEFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    methods(Static)
        [shape_func, d_shape_func] = Point1(xi)
        [shape_func, d_shape_func] = Line2(xi)
        [shape_func, d_shape_func] = Quad4(xi)
        [shape_func, d_shape_func] = Hexa8(xi)
        [ shape_function ] = MappingElementType2ShapeFunction( element_type )
    end
end

