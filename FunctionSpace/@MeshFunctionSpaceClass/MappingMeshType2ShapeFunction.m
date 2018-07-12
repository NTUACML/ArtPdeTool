function [ shape_function ] = MappingMeshType2ShapeFunction( this, mesh_type )
%MESHTYPEMAPPINGSHAPEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

    switch mesh_type
        case 'Hexa8'
            shape_function = @(xi) ShapeFunctionClass.Hexa8(xi);
        case 'Line2'
            shape_function = @(xi) ShapeFunctionClass.Line2(xi);
        otherwise
            disp('Error! Element type mapping error!');
    end

end

