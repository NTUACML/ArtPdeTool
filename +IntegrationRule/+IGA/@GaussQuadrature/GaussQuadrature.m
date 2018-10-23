classdef GaussQuadrature
    %GAUSSQUADRATURECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        [num_quadrature, position, weighting] = Hexa8()
        [num_quadrature, position, weighting] = Line2()
        [num_quadrature, position, weighting] = Quad4()
        [gauss_quadrature] = MappingNurbsType2GaussQuadrature( this, element_type, unit_span, number_quad_pnt )
    end
    
end

