function [ shape_function ] = MappingElementType2ShapeFunction( element_type )
%MESHTYPEMAPPINGSHAPEFUNCTION Summary of this function goes here
%   Detailed explanation goes here
    import Utility.MeshUtility.ElementType
    import FunctionSpace.FEM.ShapeFunction
switch element_type
    case ElementType.Point1
        shape_function = @(xi) ShapeFunction.Point1(xi);
    case ElementType.Line2
        shape_function = @(xi) ShapeFunction.Line2(xi);
    case ElementType.Quad4
        shape_function = @(xi) ShapeFunction.Quad4(xi);
    case ElementType.Hexa8
        shape_function = @(xi) ShapeFunction.Hexa8(xi);
    otherwise
        shape_function = [];
        disp('Error! Element type mapping error!');
end

end

