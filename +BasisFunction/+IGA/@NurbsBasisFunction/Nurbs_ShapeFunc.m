function [ non_zero_id, R, dR_dxi ] = Nurbs_ShapeFunc( xi, order, knot_vectors, weightings )
%NURBS_SHAPEFUNC Summary of this function goes here
%   Detailed explanation goes here
import Utility.BasicUtility.TensorProduct
import BasisFunction.IGA.NurbsBasisFunction

geoDim = length(knot_vectors);
basis_number_ = zeros(1, geoDim);
for i = 1:geoDim
    basis_number_(i) = length(knot_vectors{i})-order(i)-1;
end

TD = TensorProduct(num2cell(basis_number_));

% Evaluate basisfunction in each direction
ders = cell(1,geoDim);
spanVec = cell(1,geoDim);
for i = 1:geoDim
    [id, ders{i}] = NurbsBasisFunction.DersBasisFuns(xi(:,i), order(i) , knot_vectors{i});
    spanVec{i} = ((id - order(1)) + 1 : id + 1)';
end

num_non_zero_basis = prod(order+1);
R = zeros(1, num_non_zero_basis);
dR_dxi = zeros(geoDim, num_non_zero_basis);
non_zero_id = zeros(num_non_zero_basis, 1);

% Multiply basis functions 
sum_tol = 0;
sum_xi = zeros(1, geoDim);
cnt = 0;

switch geoDim
    case 1
        for i = 1:length(spanVec{1})
            cnt = cnt + 1;
            
            global_id = TD.to_global_index({spanVec{1}(i)});
            non_zero_id(cnt) = global_id;
            
            % R
            R(cnt) = ders{1}(i, 1) * weightings(global_id);
            sum_tol = sum_tol + R(cnt);
            
            % dR/dxi
            dR_dxi(1, cnt) = ders{1}(i, 2) * weightings(global_id);
            sum_xi(1) = sum_xi(1) + dR_dxi(1, cnt);
        end
    case 2
        for j = 1:length(spanVec{2})
            for i = 1:length(spanVec{1})
                cnt = cnt + 1;
                
                global_id = TD.to_global_index({spanVec{1}(i) spanVec{2}(j)});
                non_zero_id(cnt) = global_id;
                
                % R
                R(cnt) = (ders{1}(i, 1) * ders{2}(j, 1)) * weightings(global_id);
                sum_tol = sum_tol + R(cnt);
                
                % dR/dxi
                dR_dxi(1, cnt) = (ders{1}(i, 2) * ders{2}(j, 1)) * weightings(global_id);
                sum_xi(1) = sum_xi(1) + dR_dxi(1, cnt);
                
                % dR/deta
                dR_dxi(2, cnt) = (ders{1}(i, 1) * ders{2}(j, 2)) * weightings(global_id);
                sum_xi(2) = sum_xi(2) + dR_dxi(2, cnt);
            end
        end
    case 3
        
end


for i = 1:geoDim
    dR_dxi(i,:) = (dR_dxi(i,:) .* sum_tol - R .* sum_xi(i)) ./ sum_tol.^2;
end

R = R ./ sum_tol;

end

