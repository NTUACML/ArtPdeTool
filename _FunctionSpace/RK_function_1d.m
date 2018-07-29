function [N, dN] = RK_function_1d(x, node, order, support, id)

M = zeros(order+1);
C = zeros(size(node(id)));
H_0 = [1, zeros(1,order)];

H = cal_H_matrix(x, node, order);

r = abs(x-node(id))/support;
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
