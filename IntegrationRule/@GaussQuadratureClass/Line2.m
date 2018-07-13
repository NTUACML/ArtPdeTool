function [num_quadrature, position, weighting] = Line2()
%LINE2 Summary of this function goes here
%   Detailed explanation goes here
    xg = [-0.57735026918963D0, 0.57735026918963D0];
	w = [1.00000000000000D0, 1.00000000000000D0];
    num_quadrature = 2;
    position = xg';
    weighting = w';

end

