function [ function_space ] = FunctionSpace( domain )
%FUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here
switch domain.type
    case 'Mesh'
        switch domain.element_name
            case 'Hexa8'
                function_space.basis_number = domain.node_number;
                function_space.evaluate_basis = @ (xi) Hexa8(xi);
                function_space.non_zero_basis = @ (element_id) domain.connectivity(element_id, :);
                function_space.type = ['Mesh ', 'isoparametric ', 'Hexa8'];
        end
    case 'ScatterPoint' % TODO
    case 'NURBS' % TODO
end


% function_space.non_zero_basis_id();


end

function [shape_func, d_shape_func] = Hexa8(xi)
%*************************************************************************
% Compute shape function, derivatives, and determinant of hexahedron element
%*************************************************************************
% shape_func   : shape function value evaluated at xi
% d_shape_func : gradient of shape function evaluated at xi. d N_i / d xi_j
% Jacobian     : Jacobian matrix d x_i / d xi_j
%%
  node = [-1 -1 -1;
           1 -1 -1;
           1  1 -1;
          -1  1 -1;
          -1 -1  1;
           1 -1  1;
           1  1  1;
          -1  1  1]; 
  
  shape_func = zeros(8,1);
  d_shape_func = zeros(8,3);
  
  for I = 1:8    
    temp = [1+xi(1)*node(I, 1) 1+xi(2)*node(I, 2) 1+xi(3)*node(I, 3)];
    
    shape_func(I) = 0.125 * temp(1) * temp(2) * temp(3);
    d_shape_func(I,1) = 0.125 * node(I, 1) * temp(2) * temp(3);
    d_shape_func(I,2) = 0.125 * node(I, 2) * temp(1) * temp(3);
    d_shape_func(I,3) = 0.125 * node(I, 3) * temp(1) * temp(2);
  end
      
end
