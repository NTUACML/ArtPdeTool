function [shape_func, d_shape_func] = Hexa8(xi)
%*************************************************************************
% Compute shape function, derivatives, and determinant of hexahedron element
%*************************************************************************
% shape_func   : shape function value evaluated at xi
% d_shape_func : gradient of shape function evaluated at xi. d N_j / d xi_i
%%
  node = [-1 -1 -1;
           1 -1 -1;
           1  1 -1;
          -1  1 -1;
          -1 -1  1;
           1 -1  1;
           1  1  1;
          -1  1  1]; 
  
  shape_func = zeros(1,8);
  d_shape_func = zeros(3,8);
  
  for I = 1:8    
    temp = [1+xi(1)*node(I, 1) 1+xi(2)*node(I, 2) 1+xi(3)*node(I, 3)];
    
    shape_func(I) = 0.125 * temp(1) * temp(2) * temp(3);
    d_shape_func(1,I) = 0.125 * node(I, 1) * temp(2) * temp(3);
    d_shape_func(2,I) = 0.125 * node(I, 2) * temp(1) * temp(3);
    d_shape_func(3,I) = 0.125 * node(I, 3) * temp(1) * temp(2);
  end
      
end
