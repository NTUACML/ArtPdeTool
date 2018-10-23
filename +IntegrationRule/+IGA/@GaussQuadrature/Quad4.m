function [num_quadrature, position, weighting] = Quad4()
%HEXA8 Summary of this function goes here
%   Detailed explanation goes here
    xg = [-0.57735026918963D0, 0.57735026918963D0];
	w = [1.00000000000000D0, 1.00000000000000D0];
    num_quadrature = 4;
    position = [-0.57735026918963D0, -0.57735026918963D0;
                0.57735026918963D0, -0.57735026918963D0;
                0.57735026918963D0, 0.57735026918963D0;
                -0.57735026918963D0, 0.57735026918963D0];
    weighting = ones(4, 1);
    
end

