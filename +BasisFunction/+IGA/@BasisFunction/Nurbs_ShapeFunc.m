function [ GlobalDof, R, dR_dxi ] = Nurbs_ShapeFunc( xi, p, knots, omega )
%NURBS_SHAPEFUNC Summary of this function goes here
%   Detailed explanation goes here

GlobalShapeFuncId =@(i, j, n) n .* (j-1) + i; 
[span_id{1},ders{1}] = DersBasisFuns(xi{1}, p{1} , knots{1});
[span_id{2},ders{2}] = DersBasisFuns(xi{2}, p{2} , knots{2});

spanVec{1} = ((span_id{1} - p{1}) + 1 : span_id{1} + 1)';
spanVec{2} = ((span_id{2} - p{2}) + 1 : span_id{2} + 1)';

n = p{1} + 1;
m = p{2} + 1;
N = (length(knots{1})-1) - p{1};
Dof = n * m;

R = zeros(1, Dof);
dR_dxi = zeros(2, Dof);
GlobalDof = zeros(Dof, 1);

sum_tol = 0;
sum_xi = 0;
sum_eta = 0;

for j = 1 : m
    uDof = GlobalShapeFuncId(spanVec{1}, spanVec{2}(j), N);
    GlobalDof((j*n)-n+1: (j*n)) = uDof;
    w_u = omega(uDof);
    
    % R
    temp = (ders{2}(j, 1) .* ders{1}(:, 1)) .* w_u;
    R(1, n * (j - 1) + 1 :  n * (j - 1) + n) = temp';
    sum_tol = sum_tol + sum(temp); 
    
    % dR/dxi
    temp = (ders{2}(j, 1) .* ders{1}(:, 2)) .* w_u;
    dR_dxi(1, n * (j - 1) + 1 :  n * (j - 1) + n) = temp';
    sum_xi = sum_xi + sum(temp);
    
    % dR/deta
    temp = (ders{2}(j, 2) .* ders{1}(:, 1)) .* w_u;
    dR_dxi(2, n * (j - 1) + 1 :  n * (j - 1) + n) = temp';
    sum_eta = sum_eta + sum(temp);
end

dR_dxi(1,:) = (dR_dxi(1,:) .* sum_tol - R .* sum_xi) ./ sum_tol.^2;
dR_dxi(2,:) = (dR_dxi(2,:) .* sum_tol - R .* sum_eta) ./ sum_tol.^2;
R = R ./ sum_tol;

end

