function [ BG, BN ] = GradientMatrix( d_shape_func, F )
%GRADIENTMATRIX Summary of this function goes here
%   Detailed explanation goes here
BG = zeros(9,24);

node_number = size(d_shape_func, 1);

for I = 1:node_number
    COL = (I-1)*3+1:(I-1)*3+3;
    BG(:,COL)=[d_shape_func(I,1)   0                   0;
               d_shape_func(I,2)   0                   0;
               d_shape_func(I,3)   0                   0;
               0                   d_shape_func(I,1)   0;
               0                   d_shape_func(I,2)   0;
               0                   d_shape_func(I,3)   0;
               0                   0                   d_shape_func(I,1);
               0                   0                   d_shape_func(I,2);
               0                   0                   d_shape_func(I,3)];
end


temp = [F(1,1), 0,      0,      F(2,1), 0,      0,      F(3,1), 0,      0;
        0,      F(1,2), 0,      0,      F(2,2), 0,      0,      F(3,2), 0;
        0,      0,      F(1,3), 0,      0,      F(2,3), 0,      0,      F(3,3);
        F(1,2), F(1,1), 0,      F(2,2), F(2,1), 0,      F(3,2), F(3,1), 0;
        0,      F(1,3), F(1,2), 0,      F(2,3), F(2,2), 0,      F(3,3), F(3,2);
        F(1,3), 0,      F(1,1), F(2,3), 0,      F(2,1), F(3,3), 0,      F(3,1)];

    
BN = temp * BG;
    
    
end

