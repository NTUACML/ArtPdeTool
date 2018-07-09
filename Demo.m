function Demo
clc; clear; close all;

%% Generate domain mesh
domain = DomainBuilder('Mesh');

%% Generate integration rule
integration_rule = IntegrationRule(domain);

%% Generate function space
function_space = FunctionSpace(domain);

%% Define material property
material = MaterialBank('Mooney');

%% Define variables
% One can initialize data directly or theough dof_manager
% delta_u = VariableClass('displacement_increment', 3);
u = VariableClass('displacement', 3, function_space.basis_number);

p = VariableClass('pressure', 1);
t = VariableClass('test', 2);

u.data_ = (1:u.data_number_)';

u_1 = u.data_component(1);
u_2 = u.data_component(2);
u_3 = u.data_component(3);
%% Dof manager
% dof_manager = DofManager(delta_u, function_space);
% delta_u = dof_manager.initialize_variables(delta_u);

%% Test DOF manager
dof_manager = DofManagerClass(u, function_space, p, function_space, t, function_space);
[u, p, t] = dof_manager.initialize_variables(u, p, t);

% [dof_manager, u, p, t] = DofManager(u, function_space, p, function_space, t, function_space);
u_sequence = dof_manager.variable_sequence(u);
p_sequence = dof_manager.variable_sequence(p);
t_sequence = dof_manager.variable_sequence(t);

u_global_id = dof_manager.global_id([1 3 6 8], u);
p_global_id = dof_manager.global_id([6 2 7], p);
t_global_id = dof_manager.global_id([5 1 4], t);

u1_data = dof_manager.get_variable_data(u,1);
u2_data = dof_manager.get_variable_data(u,2);
u3_data = dof_manager.get_variable_data(u,3);
p_data = dof_manager.get_variable_data(p,1);
t1_data = dof_manager.get_variable_data(t,1);
t2_data = dof_manager.get_variable_data(t,2);
%% Boundary & Initial conditions
displacement = zeros(domain.node_number, domain.dim);

% u1 = 0 for Face 6
% u2 = 0 for Face 3
% u3 = 0 for Face 1
% u1 = lambda for Face 4

lambda = 0.1;
prescribed_bc = PrescribedDisplacement([], domain.boundary_connectivity(6,:), [1 1 1 1], [0 0 0 0]);
prescribed_bc = PrescribedDisplacement(prescribed_bc, domain.boundary_connectivity(3,:), [2 2 2 2], [0 0 0 0]);
prescribed_bc = PrescribedDisplacement(prescribed_bc, domain.boundary_connectivity(1,:), [3 3 3 3], [0 0 0 0]);
prescribed_bc = PrescribedDisplacement(prescribed_bc, domain.boundary_connectivity(4,:), [1 1 1 1], lambda*[1 1 1 1]);



%% Assembling
[ residual, tangent_matrix ] = Assembler( integration_rule, function_space, material, dof_manager, displacement );



end


