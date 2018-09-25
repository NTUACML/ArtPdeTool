function [num_quadrature, position, weighting] = Hexa8()
%HEXA8 Summary of this function goes here
%   Detailed explanation goes here
    xg = [-0.57735026918963D0, 0.57735026918963D0];
	w = [1.00000000000000D0, 1.00000000000000D0];
    num_quadrature = 8;
    position = zeros(8, 3);
    weighting = zeros(8, 1);
    for i = 1:2
        for j = 1:2
        	for k = 1:2
            	position(4*(i-1)+2*(j-1)+k, :) = [xg(i) xg(j) xg(k)];
                weighting(4*(i-1)+2*(j-1)+k) = w(i)*w(j)*w(k);
            end
        end
    end
end

