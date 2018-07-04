function [ residual, tangent_matrix ] = Assembler( integration_rule, function_space, material, dof_manager, displacement )
%ASSEMBLER Summary of this function goes here
%   Detailed explanation goes here

residual = zeros(dof_manager.total_dof_number,1);
tangent_matrix = zeros(dof_manager.total_dof_number, dof_manager.total_dof_number);

% loop over integration unit
for unit_id = 1:integration_rule.unit_number
    non_zero_basis = function_space.non_zero_basis(unit_id); % Here we assume that the integration unit is the same as approximation unit
    global_id = dof_manager.global_id(non_zero_basis);
    % loop over integration quadrature point
    for I = 1:integration_rule.unit{unit_id}.point_number 
        % evaluate deformation gradient at quadratue point
        [~, d_shape_func] = function_space.evaluate_basis(integration_rule.unit{unit_id}.position(I,:));
        
        % evaluate Jacobian matrix d X / d xi
        Jacobian = integration_rule.unit{unit_id}.Jacobian(d_shape_func); 
        
        % transform to d N_i / d X_j
        d_shape_func = inv(Jacobian)' * d_shape_func; 
        
        factor = integration_rule.unit{unit_id}.weighting(I) * det(Jacobian);
        
        % evaluate deformation gradient
        F = d_shape_func * displacement + eye(3); % TODO consider use BN matrix to evlaluate F instead
        
        % evaluate 2nd Piola-Kirchhoff stress & material stiffness 
        [PK2_stress, material_stiffness] = material.evaluate_stress(F);
        
        % evaluate gradient matrices
        [BG, BN] = GradientMatrix(d_shape_func, F);
        
        % evaluate sigma matrix
        sigma = StressMatrix(PK2_stress);
        
        % evaluate residual vector & assemble to global vector
        residual(global_id) = residual(global_id) + BN' * PK2_stress * factor;
        
        % evaluate tangent matrix & assemble to global matrix
        tangent_matrix(global_id, global_id) = tangent_matrix(global_id, global_id) + (BN' * material_stiffness * BN + BG' *sigma * BG) * factor;
    end
end

end

