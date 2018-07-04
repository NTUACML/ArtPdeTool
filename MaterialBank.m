function [ material ] = MaterialBank( name )
%MATERIALBANK Summary of this function goes here
%   Detailed explanation goes here

switch name
    case 'Mooney'
        material.Mooney_parameter = [80 20];
        material.bulk_modulus = 1E7;
        material.evaluate_stress = @ (F) Mooney(F, material.Mooney_parameter(1), material.Mooney_parameter(2), material.bulk_modulus);
        
    case 'Diffusivity'
        material.Diffusivity = @ (D) D;

    otherwise
        disp('Check name!')
end

end

function [Stress, D] = Mooney(F, A10, A01, K)
% Inputs:
% F = Deformation gradient [3x3]
% A10, A01, K = Material constants
% ltan = 0 Calculate stress alone; 1 Calculate stress and material stiffness 
% Outputs:
% Stress = 2nd PK stress [S11, S22, S33, S12, S23, S13];
% D = Material stiffness [6x6]

%% Invariants
C = F'*F;
C1=C(1,1); C2=C(2,2); C3=C(3,3); C4=C(1,2); C5=C(2,3); C6=C(1,3);
I1 = C1+C2+C3;
I2 = C1*C2+C1*C3+C2*C3-C4^2-C5^2-C6^2;
I3 = det(C);
J3 = sqrt(I3);

%% Derivatives of Invariants w.r.t E
I1E = 2*[1 1 1 0 0 0]';
I2E = 2*[C2+C3, C3+C1, C1+C2, -C4, -C5, -C6]';
I3E = 2*[C2*C3-C5^2, C3*C1-C6^2, C1*C2-C4^2,...
    C5*C6-C3*C4, C6*C4-C1*C5, C4*C5-C2*C6]';

%% Derivatives of Reduced Invariants w.r.t E
X12 = 1/2; X13 = 1/3; X23 = 2/3; X43 = 4/3; X53 = 5/3; X89 = 8/9;
W1 = I3^(-X13); W2 = X13*I1*I3^(-X43); W3 = I3^(-X23); W4 = X23*I2*I3^(-X53); W5 = X12*I3^(-X12);
 
J1E = W1*I1E - W2*I3E;
J2E = W3*I2E - W4*I3E;
J3E = W5*I3E;

%% 2nd PK Stress
Stress = A10*J1E + A01*J2E + K*(J3-1)*J3E;

%% 2nd order Derivatives of Invariants w.r.t E
% The 4th order tensor A_ijkl is re-order into a 6by6 matrix as 
% 0.5*[2*A_1111       2*A_1122       2*A_1133       A_1112+A_1121 A_1123+A_1132  A_1113+A_1131; 
%      2*A_2211       2*A_2222       2*A_2233       A_2212+A_2221 A_2223+A_2232  A_2213+A_2231; 
%      2*A_3311       2*A_3322       2*A_3333       A_3312+A_3321 A_3323+A_3332  A_3313+A_3331; 
%      A_1211+A_2111  A_1222+A_2122  A_1233+A_2133  A_1212+A_1221 A_1223+A_1232  A_1213+A_1231;
%      A_2311+A_3211  A_2322+A_3222  A_2333+A_3233  A_2312+A_2321 A_2323+A_2332  A_2313+A_2331;
%      A_1311+A_3111  A_1322+A_3122  A_1333+A_3133  A_1312+A_1321 A_1323+A_1332  A_1313+A_1331];

I2EE = [0  4  4  0  0  0; 
        4  0  4  0  0  0; 
        4  4  0  0  0  0; 
        0  0  0 -2  0  0;
        0  0  0  0 -2  0;
        0  0  0  0  0 -2];
    
I3EE = [   0   4*C3    4*C2      0   -4*C5       0; 
        4*C3      0    4*C1      0       0   -4*C6; 
        4*C2   4*C1       0  -4*C4       0       0;
           0      0   -4*C4  -2*C3    2*C6    2*C5;
       -4*C5      0       0   2*C6   -2*C1    2*C4; 
           0  -4*C6       0   2*C5    2*C4   -2*C2];

%% 2nd order Derivatives of Reduced Invariants w.r.t E
W1 = X23*I3^(-X12);
W4 = X43*I3^(-X12);
W7 = X23*I2*I3^(-X53); W8 = I3^(-X12); W9 = X12*I3^(-X12);
W2 = X89*I1*I3^(-X43); W3 = X13*I1*I3^(-X43); W5 = X89*I2*I3^(-X53); W6 = I3^(-X23);

J1EE = -W1*(J1E*J3E' + J3E*J1E') + W2*(J3E*J3E') - W3*I3EE;
J2EE = -W4*(J2E*J3E' + J3E*J2E') + W5*(J3E*J3E') + W6*I2EE - W7*I3EE; 
J3EE = -W8*(J3E*J3E') + W9*I3EE;

%% Material Stiffness
D = A10*J1EE + A01*J2EE + K*(J3E*J3E') + K*(J3-1)*J3EE;

end
