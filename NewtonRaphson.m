function [ u ] = NewtonRaphson( tangent, residual, u, tolerance, maximum_iteration_number )
%NEWTON_RAPHSON Summary of this function goes here
% Newton-Raphson method to solve P(u) = f, where P is nonlinear functions
% of u. 
% The method solve delta u from " K delta u = -R = -(P-f) ", with tangent
% matrix K = dP / du
%
% tangent(u): function handle to compute the tangent matrix K
% residual(u): function handle to comput the residule R = P-f
% u: initial guess
% tol: tolerance
% max_iter: maximum iteration number

iteration_step = 0;
uold = u;

residual_norm = dot(residual, residual);

fprintf('\n iter conv');
fprintf('\n %4d %12.3e',iteration_step, residual_norm);

while residual_norm > tolerance && iteration_step < maximum_iteration_number
    Kt = tangent(u);
    delu = -Kt\residual;
    u = uold + delu;
        
    residual_norm= dot(residual, residual);
    
    uold = u;
    iteration_step = iteration_step + 1;
    
    fprintf('\n %4d %12.3e',iteration_step, residual_norm);
end

end


