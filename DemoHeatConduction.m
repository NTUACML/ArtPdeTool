function DemoHeatConduction
clc; clear; close all;

%% Include package
addpath Domain
addpath FunctionSpace
addpath IntegrationRule

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
        [F, J] = evaluate_jacobian(dN_dxi);
        % local mass assembing.
        mass_mat = mass_mat + (N'*N) .* (gauss_w * J);
        %%%%%%%%% Assember Part (End) %%%%%%%%%
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Quarry unit(Integral unit in mesh type method)
% function_space_quarry_unit = 1; 
% 
% % Evaluated position in parameter coordinates (parent coordiantes)
% evaluate_xi_position = [0, 0, 0]; % For 'UnitCube' domain
% % evaluate_xi_position = [0]; % For 'StraightLine' domain
% 
% % Quarry function space for the infomation of non_zero_basis within quarry  
% % unit and which evaluational methods.
% [non_zero_basis, evaluate_basis] = function_space.quarry...
%                                         (function_space_quarry_unit);
% 
% % Get non-zero basis id in the quarry unit.
% non_zero_basis_id = non_zero_basis();
% 
% % Calculated shape function and derivatives on the position.
% % (parameter coordinates or parent coordiantes)
% [N, dN_dxi] = evaluate_basis(evaluate_xi_position);
% 
% % show results
% disp(non_zero_basis_id);
% disp(N);
% disp(dN_dxi);
% 
% % P.S.: Basis function information and feature point.
% disp(['Total basis number in domain: ', int2str(function_space.num_basis_)])
% disp(['The first basis info: Basis Id ->', int2str(function_space.basis_{1}.id_)...
%       ' , Feature point ->']);
% disp(function_space.basis_{1}.data_())
% % %%%%%%%%%%%%%%%%



% 
% %% Define material property
% material = MaterialBank('Diffusivity');
% 
% %% Define variables
% dof_number = 1;
% 
% delta_T = Variable('temperature_increment', dof_number);
% T = Variable('temperature_total', dof_number, domain.node_number);
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


