function DemoHeatConduction
clc; clear; close all;

%% Include package
addpath Domain
addpath FunctionSpace
addpath IntegrationRule
addpath Variable

%% Generate domain mesh
domain_builder = DomainBuilderClass('Mesh');
domain_builder.generateData('UnitCube');
% domain_builder.generateData('StraightLine');
domain = domain_builder.getDomainData();

if(domain_builder.status_)
    clear domain_builder;
end

%% Generate integration rule
integration_rule_builder = IntegrationRuleBuilderClass('Mesh');
integration_rule_builder.generateData(domain); % isoparametric 
% integration_rule_builder.generateData('Some Special Domain'); 
integration_rule = integration_rule_builder.getIntegrationRuleData();

if(integration_rule_builder.status_)
    clear integration_rule_builder;
end

% [int_unit, evaluate_jacobian] = integration_rule.quarry(1);

%% Generate function space
function_space_builder = FunctionSpaceBuilderClass(domain);
function_space_builder.generateData();
function_space = function_space_builder.getFunctionSpaceData();

if(function_space_builder.status_)
    clear function_space_builder;
end

%% Demo for FEM integration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loop for all the integrational unit (element)
for ele_id = 1 : integration_rule.num_int_unit_
    % quarry the integrational unit (gauss quadrature data) and the jacobian 
    % calculating information (Jacobian matrix (F) and which determinant) 
    % in each element. 
    [int_unit, evaluate_jacobian] = integration_rule.quarry(ele_id);
    
    % quarry the non_zero_basis (for matrix assembler) and the calculating 
    % method for basis function (shape function and which derivatives)
    % in each element. 
    
    % Jeting 0724. Here, we can use test and trial space to call function
    % space, in test space, those basis with zero value at prescribed
    % Dirichlet boundary will be ignored. 
    %
    % Example:
    % [non_zero_trial, evaluate_trial] = trial_space.quarry(ele_id);
    % [non_zero_test, evaluate_test] = test_space.quarry(ele_id);
    %
    % 'non_zero_test' is a subset of 'non_zero_trial'
    % However, we do not want to compute those repeated basis function
    % value. So in practice, we should call 'evaluate_trial' first. 
    % When we call 'evaluate_test', it does not really compute the basis value. 
    % It will directly output part of the values we just obtained in
    % 'evaluate_trial'.
    % similar idea for 'non_zero_basis'
    % To do this, one way is that consider test & trial spaces as the
    % calling interface of the same function space. In other word,
    % test_space & trial_space will have the same function_space pointer as their member
    % Hence, if something is modified in trial space, test space can just
    % simply output the results without re-compute again.
    [non_zero_basis, evaluate_basis] = function_space.quarry(ele_id);
    
    % get gauss quadrature rule for each isoparametric element.
    [num_gauss, gauss_pt, gauss_w] = int_unit();
    
    % get global assembler id and local stifness matrix size
    non_zero_basis_id = non_zero_basis();
    
    % mass matrix 
    mass_mat = zeros(length(non_zero_basis_id));
    
    % loop gauss point (calculating data in gauss position)
    for gauss_id = 1 : num_gauss
        xq = gauss_pt(gauss_id,:);
        w = gauss_w(gauss_id);
        
        %%%%%%%%% Assember Part (Start) %%%%%%%%%
        % get basis function and which derivatives at gauss point.
        [N, dN_dxi] = evaluate_basis(xq);
        % get mapping matrix (F) and jacobian.
        [dx_dxi, J] = evaluate_jacobian(dN_dxi);
        % local mass assembing.
        mass_mat = mass_mat + (N'*N) .* (w * J);
        %%%%%%%%% Assember Part (End) %%%%%%%%%
        
        % Jeting 0724
        % [N_trial, dN_dxi_trial] = evaluate_trial(xq);
        % [N_test, dN_dxi_test] = evaluate_test(); 
        % Since this function only ouputs the results computed from 'evaluate_trial'. 
        % No input argument is necessary.
        
        % get mapping matrix (F) and jacobian.
        % [dx_dxi, J] = evaluate_jacobian(dN_dxi_trial);
            
        % directly global assembing.
        % mass_mat(non_zero_test, non_zero_trial) = mass_mat(non_zero_test,
        % non_zero_trial) + (N_test'*N_trial) .* (w * J);
        
        % rhs(non_zero_test) += N_test*h; for natural bc

        % Nitsche' method for imposing essential bc
        % essential_mat(non_zero_test, non_zero_trial) = essential_mat(non_zero_test,
        % non_zero_trial) + (N_test'*dN_dxi_trial + dN_dxi_test'*N_trial) .* (w * J);
        
        % strongly imposing essential bc
        % essential_mat(~non_zero_test, :) = 0;
        % essential_mat(~non_zero_test, ~non_zero_test) = 1;
        % rhs(~non_zero_test) = g;
    end
    
end


% 
% %% Define material property
% material = MaterialBank('Diffusivity');
% 
%% Define variables
dof_number = 1;

delta_T = VariableClass('temperature_increment', dof_number);
T = VariableClass('temperature_total', dof_number, function_space);

% 
% %% Dof manager
% [dof_manager_T, delta_T] = DofManager(delta_T, function_space);

%% Boundary & Initial conditions

% % u1 = 0 for Face 6
% % u2 = 0 for Face 3
% % u3 = 0 for Face 1
% % u1 = lambda for Face 4
% 
% lambda = 0.1;
% prescribed_bc = PrescribedDisplacement([], domain.boundary_connectivity(6,:), [1 1 1 1], [0 0 0 0]);
% prescribed_bc = PrescribedDisplacement(prescribed_bc, domain.boundary_connectivity(3,:), [2 2 2 2], [0 0 0 0]);
% prescribed_bc = PrescribedDisplacement(prescribed_bc, domain.boundary_connectivity(1,:), [3 3 3 3], [0 0 0 0]);
% prescribed_bc = PrescribedDisplacement(prescribed_bc, domain.boundary_connectivity(4,:), [1 1 1 1], lambda*[1 1 1 1]);
% 
% 
% 
% %% Assembling
% [ residual, tangent_matrix ] = Assembler( integration_rule, function_space, material, dof_manager, displacement );
% 
% 

end


