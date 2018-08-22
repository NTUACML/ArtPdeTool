function [ gauss_quadrature ] = MappingElementType2GaussQuadrature(element_type )
%MAPPINGELEMENTTYPE2GAUSSQUADRATURE Summary of this function goes here
%   Detailed explanation goes here
import Utility.MeshUtility.ElementType
import IntegrationRule.FEM.GaussQuadrature

switch element_type
    case ElementType.Hexa8
        gauss_quadrature = @() GaussQuadrature.Hexa8();
    case ElementType.Line2
        gauss_quadrature = @() GaussQuadrature.Line2();
    otherwise
        gauss_quadrature = [];
        disp('Error! Element type mapping error!');
end

end

