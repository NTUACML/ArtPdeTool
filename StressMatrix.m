function [ sigma ] = StressMatrix( PK2_stress )
%STRESSMATRIX Summary of this function goes here
%   Detailed explanation goes here
temp = [PK2_stress(1), PK2_stress(4), PK2_stress(6);
        PK2_stress(4), PK2_stress(2), PK2_stress(5);
        PK2_stress(6), PK2_stress(5), PK2_stress(3)];

sigma = zeros(9);
sigma(1:3,1:3) = temp;
sigma(4:6,4:6) = temp;
sigma(7:9,7:9) = temp;
    
end

