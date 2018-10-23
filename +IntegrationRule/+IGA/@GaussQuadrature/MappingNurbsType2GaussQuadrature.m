function [ gauss_quadrature ] = MappingNurbsType2GaussQuadrature(nurbs_type, unit_span, number_quad_pnt )
%MAPPINGELEMENTTYPE2GAUSSQUADRATURE Summary of this function goes here
%   Detailed explanation goes here
import Utility.NurbsUtility.NurbsType
import IntegrationRule.IGA.GaussQuadrature

switch nurbs_type
    case NurbsType.Solid
        [num_quadrature, position, weighting] = GaussQuadrature.Hexa8();
        lu = unit_span{1}(2)-unit_span{1}(1);
        position(:,1) = 0.5*(position(:,1)+1)*lu + unit_span{1}(1);
        weighting = weighting/2*lu;
        gauss_quadrature = {num_quadrature, position, weighting};
    case NurbsType.Surface
        [num_quadrature, position, weighting] = GaussQuadrature.Quad4();
        lu = unit_span{1}(2)-unit_span{1}(1);
        lv = unit_span{2}(2)-unit_span{2}(1);
        position(:,1) = 0.5*(position(:,1)+1)*lu + unit_span{1}(1);
        position(:,2) = 0.5*(position(:,2)+1)*lv + unit_span{2}(1);
        weighting = weighting/4*lu*lv;
        gauss_quadrature = {num_quadrature, position, weighting};
    case NurbsType.Curve
        [num_quadrature, position, weighting] = GaussQuadrature.Line2();
        lu = unit_span{1}(2)-unit_span{1}(1);
        lv = unit_span{2}(2)-unit_span{2}(1);
        lw = unit_span{2}(2)-unit_span{2}(1);
        position(:,1) = 0.5*(position(:,1)+1)*lu + unit_span{1}(1);
        position(:,2) = 0.5*(position(:,2)+1)*lv + unit_span{2}(1);
        position(:,3) = 0.5*(position(:,3)+1)*lw + unit_span{3}(1);
        weighting = weighting/8*lu*lv*lw;
        gauss_quadrature = {num_quadrature, position, weighting};
    otherwise
        gauss_quadrature = [];
        disp('Error! Nurbs type mapping error!');
end

end


