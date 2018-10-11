function [shape_func, d_shape_func] = Point1(xi)
%*************************************************************************
% Compute shape function, derivatives, and determinant of line element
%*************************************************************************
% shape_func   : shape function value evaluated at xi
% d_shape_func : gradient of shape function evaluated at xi. d N_j / d xi_i
%%
  shape_func = 1;
  d_shape_func = 0;
end

