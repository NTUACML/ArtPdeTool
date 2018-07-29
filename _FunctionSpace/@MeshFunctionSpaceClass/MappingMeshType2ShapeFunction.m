function [ shape_function ] = MappingMeshType2ShapeFunction( this, mesh_type )
%MESHTYPEMAPPINGSHAPEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

switch mesh_type
    case ElementType.Hexa8
        shape_function = @(xi) ShapeFunctionClass.Hexa8(xi);
    case ElementType.Line2
        shape_function = @(xi) ShapeFunctionClass.Line2(xi);
    otherwise
        shape_function = [];
        disp('Error! Element type mapping error!');
end

end

