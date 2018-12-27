function [ non_zero_id, R, dR_dxi ] = Nurbs_ShapeFunc( xi, order, knot_vectors, weightings, content )
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
    [id, ders{i}] = NurbsBasisFunction.DersBasisFuns(xi(:,i), order(i) , knot_vectors{i}, content);
    spanVec{i} = ((id - order(i)) + 1 : id + 1)';
end

num_non_zero_basis = prod(order+1);
non_zero_id = zeros(num_non_zero_basis, 1);
R = zeros(1, num_non_zero_basis);
dR_dxi = [];

% Multiply basis functions 
sum_tol = 0;
sum_xi = [];
cnt = 0;

switch geoDim
    case 1
        switch content
            case 0 % Evuluate value only
                for i = 1:length(spanVec{1})
                    cnt = cnt + 1;
                    
                    global_id = TD.to_global_index({spanVec{1}(i)});
                    non_zero_id(cnt) = global_id;
                    
                    % R
                    R(cnt) = ders{1}(i, 1) * weightings(global_id);
                    sum_tol = sum_tol + R(cnt);
                end
            case 1 % Evuluate both derivative & value
                dR_dxi = zeros(geoDim, num_non_zero_basis);
                sum_xi = zeros(1, geoDim);
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
            otherwise
                disp('Currently not support evluating derivatives of order more than one.');
        end
    case 2
        switch content
            case 0 % Evuluate value only
                for j = 1:length(spanVec{2})
                    for i = 1:length(spanVec{1})
                        cnt = cnt + 1;
                        
                        global_id = TD.to_global_index({spanVec{1}(i) spanVec{2}(j)});
                        non_zero_id(cnt) = global_id;
                        
                        % R
                        R(cnt) = (ders{1}(i, 1) * ders{2}(j, 1)) * weightings(global_id);
                        sum_tol = sum_tol + R(cnt);
                    end
                end
            case 1 % Evuluate both derivative & value
                dR_dxi = zeros(geoDim, num_non_zero_basis);
                sum_xi = zeros(1, geoDim);
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
            otherwise
                disp('Currently not support evluating derivatives of order more than one.');
        end
    case 3
        switch content
            case 0 % Evuluate value only
                for k = 1:length(spanVec{3})
                    for j = 1:length(spanVec{2})
                        for i = 1:length(spanVec{1})
                            cnt = cnt + 1;
                            
                            global_id = TD.to_global_index({spanVec{1}(i) spanVec{2}(j) spanVec{3}(k)});
                            non_zero_id(cnt) = global_id;
                            
                            % R
                            R(cnt) = (ders{1}(i, 1) * ders{2}(j, 1) * ders{3}(k, 1)) * weightings(global_id);
                            sum_tol = sum_tol + R(cnt);
                        end
                    end
                end
            case 1 % Evuluate both derivative & value
                dR_dxi = zeros(geoDim, num_non_zero_basis);
                sum_xi = zeros(1, geoDim);
                for k = 1:length(spanVec{3})
                    for j = 1:length(spanVec{2})
                        for i = 1:length(spanVec{1})
                            cnt = cnt + 1;
                            
                            global_id = TD.to_global_index({spanVec{1}(i) spanVec{2}(j) spanVec{3}(k)});
                            non_zero_id(cnt) = global_id;
                            
                            % R
                            R(cnt) = (ders{1}(i, 1) * ders{2}(j, 1) * ders{3}(k, 1)) * weightings(global_id);
                            sum_tol = sum_tol + R(cnt);
                            
                            % dR/dxi
                            dR_dxi(1, cnt) = (ders{1}(i, 2) * ders{2}(j, 1) * ders{3}(k, 1)) * weightings(global_id);
                            sum_xi(1) = sum_xi(1) + dR_dxi(1, cnt);
                            
                            % dR/deta
                            dR_dxi(2, cnt) = (ders{1}(i, 1) * ders{2}(j, 2) * ders{3}(k, 1)) * weightings(global_id);
                            sum_xi(2) = sum_xi(2) + dR_dxi(2, cnt);
                            
                            % dR/dzeta
                            dR_dxi(3, cnt) = (ders{1}(i, 1) * ders{2}(j, 1) * ders{3}(k, 2)) * weightings(global_id);
                            sum_xi(3) = sum_xi(3) + dR_dxi(3, cnt);
                        end
                    end
                end
            otherwise
                disp('Currently not support evluating derivatives of order more than one.');
        end
        
        
end


if content ~= 0
    for i = 1:geoDim
        dR_dxi(i,:) = (dR_dxi(i,:) .* sum_tol - R .* sum_xi(i)) ./ sum_tol.^2;
    end
end

R = R ./ sum_tol;

end

