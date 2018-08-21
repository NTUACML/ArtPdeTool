classdef GaussQuadratureClass
    %GAUSSQUADRATURECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        [num_quadrature, position, weighting] = Hexa8()
        [num_quadrature, position, weighting] = Line2()
    end
    
end

