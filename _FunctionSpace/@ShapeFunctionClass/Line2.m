function [shape_func, d_shape_func] = Line2(xi)
%*************************************************************************
% Compute shape function, derivatives, and determinant of line element
%*************************************************************************
% shape_func   : shape function value evaluated at xi
% d_shape_func : gradient of shape function evaluated at xi. d N_j / d xi_i
%%
  shape_func = ([1-xi,1+xi]/2);
  d_shape_func = [-1,1]/2;
end

