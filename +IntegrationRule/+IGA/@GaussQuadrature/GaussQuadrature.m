classdef GaussQuadrature
    %GAUSSQUADRATURECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        [num_quadrature, position, weighting] = Hexa8()
        [num_quadrature, position, weighting] = Line2()
        [num_quadrature, position, weighting] = Quad4()
        [ gauss_quadrature ] = MappingElementType2GaussQuadrature( this, element_type )
    end
    
end

