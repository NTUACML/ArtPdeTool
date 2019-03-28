function [num_quadrature, position, weighting] = Quad4()
%Quad4 Summary of this function goes here
%   Detailed explanation goes here
%     xg = [-0.57735026918963D0, 0.57735026918963D0];
% 	w = [1.00000000000000D0, 1.00000000000000D0];
   
    xg = [-0.577350269189626, 0.577350269189626]';
	w = [1, 1]';
    n = 2;      
    
    [x, y] = meshgrid(xg, xg);
    [wx, wy] = meshgrid(w, w);
    
    num_quadrature = n^2;
    position = [x(:), y(:)];
    weighting = wx(:).*wy(:);
    
%     [-0.57735026918963D0, -0.57735026918963D0;
%                 0.57735026918963D0, -0.57735026918963D0;
%                 0.57735026918963D0, 0.57735026918963D0;
%                 -0.57735026918963D0, 0.57735026918963D0];
    
    
end

