function DemoHeatConduction
clc; clear; close all;

%% Generate domain mesh
addpath domain

domain_builder = DomainBuilderClass('Mesh');
domain_builder.generateData('UnitCube');
domain = domain_builder.getDomainData();

domain_builder.generateData('StraightLine');
domain_1 = domain_builder.getDomainData();

if(domain_builder.status_)
    clearvars domain_builder;
end


% %% Generate integration rule
% integration_rule = IntegrationRule(domain);
% 
% %% Generate function space
% function_space = FunctionSpace(domain);
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


