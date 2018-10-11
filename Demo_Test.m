clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*

%% Geometry data input
fem_unit_cube_geo = GeometryBuilder.create('FEM', 'UnitCube');
iso_topo = fem_unit_cube_geo.topology_data_{1};

%% Domain create
fem_domain = DomainBuilder.create('FEM');

%% Basis create
fem_linear_basis = fem_domain.generateBasis(iso_topo);

%% Variable define
var_u = fem_domain.generateVariable('velocity', fem_linear_basis,...
                                    VariableType.Vector, 3);
var_p = fem_domain.generateVariable('pressure', fem_linear_basis,...
                                    VariableType.Scalar, 1);                             
% disp(var_u);
% disp(var_p);

%% Test variable define
test_u = fem_domain.generateTestVariable(var_u, fem_linear_basis);
test_p = fem_domain.generateTestVariable(var_p, fem_linear_basis);

%% Constraint (Acquire prescribed D.O.F.)
up_side_patch = iso_topo.getBoundayPatch('Up_Side');
constraint = fem_domain.generateConstraint(up_side_patch, var_u, {1, @()1});

% 
% exp1 = Dot(Grad(test_u), Grad(var_u)); %+ test_p * var_p;
% exp2 = test_u * var_u;
% exp3 = test_p * var_p;
% %exp3.static(var_xxx)
% 
% fem_domain.int(exp1, topo, p=2);
% 
% fem_domain.boundary('xx_patch').int(exp2);
% 
% fem_domain.solver('BiCG').solve();
% 
% interpo_basis = fem_domain.generateBasis(interpo_topo);
% 
% intpo_some = Interpolation('Methods', interpo_basis);
% 
% interpo_var_u = intpo_some(target_topo, var_u);


% %% Domain create
% fem_domain_u = FEM_Domain(var_u, fem_unit_cube_geo);
% fem_domain_p = FEM_Domain(var_p, fem_unit_cube_geo);
% 
% %% Boundary condition create
% % Type 1 (General description)
% bc_u_up = BoundaryCondition('Up_Side', var_u);
% bc_u_up.setDirichlet({1 1 1})
% bc_u_up.setNeumann({0 0}, 'component', [2 3])
% % disp(bc_u_up)
% 
% % Type 2 (weak formulation description) - Essential
% bc_u_down = BoundaryCondition('Down_Side', var_u);
% bc_u_down.setEssential({1 0 0})
% % disp(bc_u_down)
% 
% % Type 3 (weak formulation description) - Traction
% bc_u_right = BoundaryCondition('Right_Side', var_u);
% bc_u_right.setTraction({100 0 0})
% % disp(bc_u_right)
% 
% % Type 4 (direct force) - Essential
% bc_u_G = BoundaryCondition('G_Point', var_u);
% bc_u_G.setEssential({1 0 0})
% % disp(bc_u_G)
% 
% %% Boundary condition impose on the domain
% fem_domain_u.setBoundaryCondition(bc_u_up);
% fem_domain_u.setBoundaryCondition(bc_u_down);
% fem_domain_u.setBoundaryCondition(bc_u_G);
% 
% %% System constructioned by Domain Mannger (DM)
% DM = DomainMannger();
% DM.addDomain(fem_domain_u);
% DM.addDomain(fem_domain_p);
% 
% global_id_u = DM.queryAssemblyId(fem_domain_u, [1, 2, 3, 4]);
% global_id_p = DM.queryAssemblyId(fem_domain_p, [1, 2, 3, 4]);










% % test
% u_int_rule = fem_domain_u.interior_domain_.intergation_rule_;
% u_fs = fem_domain_u.interior_domain_.function_space_;
% 
% unit_id = 1;
% int_unit = u_int_rule.integral_unit_data_{1};
% 
% u_fs.query(int_unit);
% 
% [n_q, xi, w] = int_unit.gauss_quadrature_();
% n_q
% xi
% w
% 
% q_id = 1
% 
% [N, dN_dxi] = int_unit.evaluate_basis_(xi(q_id, :))
% non_zero_id = int_unit.non_zero_id_




% 


% interior_patch = Utility.MeshUtility.Patch.InteriorPatch(3, 'Interoir');
% boundary_patch = Utility.MeshUtility.Patch.BoundaryPatch(3, 'Boundary');


% mesh_type_domain = MeshDomain();
% mesh_type_domain.generate('UnitCube');
% %% Domain
% mesh_type_domain = DomainBuilder.create('Mesh', 'UnitCube');
% 
% % Function Space
% import Utility.BasicUtility.Order
% 
% % function_space = FunctionSpaceBuilder.create('FEM', mesh_type_domain); % default(Linear)
% function_space = FunctionSpaceBuilder.create('FEM', mesh_type_domain, {Order.Linear});
% 
% %% Function Space (Query - Preprocess)
% import FunctionSpace.QueryUnit.FEM.QueryUnit
% import Utility.BasicUtility.Region
% import Utility.BasicUtility.Procedure
% 
% fs_query_unit = QueryUnit();
% disp( '>* querying : interior domain, element - 1, parametric position is [0, 0, 0]');
% fs_query_unit.setQuery(Region.Interior, 1, [0, 0, 0]);
% [non_zeros_id, ~] = function_space.query(fs_query_unit, Procedure.Preprocess);
% disp('Non_zeros_id : ');
% disp(non_zeros_id);
% 
% %% Function Space (Query - Runtime)
% import FunctionSpace.QueryUnit.FEM.QueryUnit
% import Utility.BasicUtility.Region
% import Utility.BasicUtility.Procedure
% 
% fs_query_unit = QueryUnit();
% disp( '>* querying : boundary domain, element - 2, parametric position is [-1, 1, 0]')
% fs_query_unit.setQuery(Region.Boundary, 2, [-1, 1, 0]);
% [non_zeros_id, basis_value] = function_space.query(fs_query_unit); %default(Runtime)
% N = basis_value{1};
% dN_dxi = basis_value{2};
% disp('non_zeros_id :');
% disp(non_zeros_id);
% disp('N :');
% disp(N);
% disp('dN_dxi :');
% disp(dN_dxi);
% 
% 
% %% RKPM Domain & Function Space test
% import Utility.BasicUtility.Order
% %% Domain
% point_type_domain = DomainBuilder.create('ScatterPoint', 'StraightLine');
% % point_type_domain = DomainBuilder.create('ScatterPoint', 'UnitSquare');
% 
% %% Function Space
% support_size_ratio = 2.5;
% function_space = FunctionSpaceBuilder.create('RKPM', point_type_domain, {Order.Quadratic, support_size_ratio}); % default(Linear, support_size_ratio = 1.5)
% 
% %% Function Space (Query - Preprocess)
% import FunctionSpace.QueryUnit.RKPM.QueryUnitRKPM
% 
% fs_query_unit = QueryUnitRKPM();
% disp( '>* querying : position is 0.06');
% fs_query_unit.setQuery(0.06);
% [non_zeros_id, basis_value] = function_space.query(fs_query_unit);
% 
% N = basis_value{1};
% dN_dxi = basis_value{2};
% disp('non_zeros_id :');
% disp(non_zeros_id);
% disp('N :');
% disp(N);
% disp('dN_dxi :');
% disp(dN_dxi);

% figure; hold on;
% x = linspace(0,1,101);
% for t = x
%     fs_query_unit.setQuery(t);
%     [non_zeros_id, basis_value] = function_space.query(fs_query_unit);
%     plot(t, basis_value{1}', 'k.');
% end

