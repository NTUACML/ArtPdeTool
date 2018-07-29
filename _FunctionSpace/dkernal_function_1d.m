function dphi = dkernal_function_1d(z, support)
%KERNAL_FUNCTION_1D Summary of this function goes here
%   Detailed explanation goes here

dphi = dcubic_bspline(z)/ support/ support;

end

function dphi = dcubic_bspline(r)
%CUBIC_BSPLINE Summary of this function goes here
%   Detailed explanation goes here

r = abs(r);
dphi = zeros(size(r));

bool = r <= 0.5;
dphi(bool) = eval_2(r(bool));

bool = r > 0.5 & r < 1;
dphi(bool) = eval_3(r(bool));

bool = r > 1;
dphi(bool) = 0;

end

function val = eval_2(r)

val = - 8*r + 12*r.^2;

end

function val = eval_3(r)

val = - 4 + 8*r - 4*r.^2;

end
