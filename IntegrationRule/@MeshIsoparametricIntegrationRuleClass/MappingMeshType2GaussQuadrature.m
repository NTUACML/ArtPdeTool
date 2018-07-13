function [ gauss_quadrature ] = MappingMeshType2GaussQuadrature( this, mesh_type )
%MAPPINGMESHTYPE2GAUSSQUADRATURE Summary of this function goes here
%   Detailed explanation goes here

switch mesh_type
    case ElementType.Hexa8
        gauss_quadrature = @() GaussQuadratureClass.Hexa8();
    case ElementType.Line2
        gauss_quadrature = @() GaussQuadratureClass.Line2();
    otherwise
        gauss_quadrature = [];
        disp('Error! Element type mapping error!');
end

end

