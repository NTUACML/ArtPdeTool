function phi = kernal_function_1d(z, support)
%KERNAL_FUNCTION_1D Summary of this function goes here
%   Detailed explanation goes here

phi = cubic_bspline(z)/ support;

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
