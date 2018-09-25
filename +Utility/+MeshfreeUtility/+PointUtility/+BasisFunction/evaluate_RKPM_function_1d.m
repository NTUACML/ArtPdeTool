function [non_zeros_id, basis_value] = evaluate_RKPM_function_1d(evaluate_position, node_data, order, support)
    % find non-zero basis
    temp = abs(evaluate_position-node_data);
    non_zeros_id = find( temp<= support);
    % evaluate basis
    import Utility.BasicUtility.Order
    switch order
        case Order.Linear
            order_ = 1;
        case Order.Quadratic
            order_ = 2;
        case Order.Cubic
            order_ = 3;
        otherwise
            disp('Input order not support');
    end
    [basis_value{1}, basis_value{2}] =  RK_function_1d(evaluate_position, node_data, order_, support(non_zeros_id), non_zeros_id);
end

%% evaluate RK functions
function [N, dN] = RK_function_1d(x, node, order, support, id)

M = zeros(order+1);
C = zeros(size(node(id)));
H_0 = [1, zeros(1,order)];

H = cal_H_matrix(x, node, order);

r = abs(x-node(id))./support;
phi = kernal_function_1d(r, support);

for i = 1:length(node(id))
    M = M + H(:,id(i))*H(:,id(i))'*phi(i); 
end

inv_M = inv(M);

for i = 1:length(node(id))
    C(i) = H_0 * inv_M * H(:,id(i));
end

N = C.*phi;

dM = zeros(order+1);
dC = zeros(size(node(id)));
dH = cal_dH_matrix(x, node, order);
dphi = dkernal_function_1d(r, support);

for i = 1:length(node(id))
    dM = dM + dH(:,id(i))*H(:,id(i))'*phi(i) ...
        + H(:,id(i))*( dH(:,id(i))'*phi(i) + H(:,id(i))'*dphi(i) );
end

dinv_M = -inv_M*dM*inv_M;

for i = 1:length(node(id))
    dC(i) = H_0 * ( dinv_M * H(:,id(i)) + inv_M * dH(:,id(i)) );
end

dN = dC.*phi + C.*dphi;


end

function H = cal_H_matrix(x, x_i, order)

H = zeros(order+1, length(x_i));

for i = 1:length(x_i)
    H(:,i) = monomial_function_1d(x, x_i(i), order);
end

end

function dH = cal_dH_matrix(x, x_i, order)

dH = zeros(order+1, length(x_i));

for i = 1:length(x_i)
    dH(:,i) = dmonomial_function_1d(x, x_i(i), order);
end

end

function H = monomial_function_1d( x, node, order )
%MONOMIAL_FUNCTION_1D Summary of this function goes here
%   x   : double, position where H is to be computed
%   x_c : double, center of monomials

H = zeros(order+1, 1);

x = x-node;

for i = 1:order+1
    H(i) = x^(i-1);
end

end

function dH = dmonomial_function_1d( x, node, order )
%MONOMIAL_FUNCTION_1D Summary of this function goes here
%   x   : double, position where H is to be computed
%   x_c : double, center of monomials

dH = zeros(order+1, 1);

x = x-node;

dH(1) = 0;

for i = 2:order+1
    dH(i) = (i-1)*x^(i-2);
end

end
%% Kernal functions
function phi = kernal_function_1d(z, support)
%KERNAL_FUNCTION_1D Summary of this function goes here
%   Detailed explanation goes here

phi = cubic_bspline(z)./ support;

end

function phi = cubic_bspline(r)
%CUBIC_BSPLINE Summary of this function goes here
%   Detailed explanation goes here

r = abs(r);
phi = zeros(size(r));

bool = r <= 0.5;
phi(bool) = eval_2(r(bool));

bool = r > 0.5 & r < 1;
phi(bool) = eval_3(r(bool));

bool = r > 1;
phi(bool) = 0;

end

function val = eval_2(r)
r2 = r.^2;
r3 = r2.*r;

val = 2/3 - 4*r2 + 4*r3;

end

function val = eval_3(r)
r2 = r.^2;
r3 = r2.*r;

val = 4/3 - 4*r + 4*r2 - 4/3*r3;

end
%% dKernal functions
function dphi = dkernal_function_1d(z, support)
%KERNAL_FUNCTION_1D Summary of this function goes here
%   Detailed explanation goes here

dphi = dcubic_bspline(z)./ (support.^2);

end

function dphi = dcubic_bspline(r)
%CUBIC_BSPLINE Summary of this function goes here
%   Detailed explanation goes here

r = abs(r);
dphi = zeros(size(r));

bool = r <= 0.5;
dphi(bool) = eval_4(r(bool));

bool = r > 0.5 & r < 1;
dphi(bool) = eval_5(r(bool));

bool = r > 1;
dphi(bool) = 0;

end

function val = eval_4(r)

val = - 8*r + 12*r.^2;

end

function val = eval_5(r)

val = - 4 + 8*r - 4*r.^2;

end

