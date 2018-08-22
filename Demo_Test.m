clc; clear; close all;

%% Include package
import Geometry.*
import Variable.*
import Domain.*

fem_unit_cube_geo = GeometryBuilder.create('FEM', 'UnitCube');
var_u = Variable('velocity', 3);
var_p = Variable('pressure', 1);
fem_domain_u = FEM_Domain(var_u, fem_unit_cube_geo);
fem_domain_p = FEM_Domain(var_p, fem_unit_cube_geo);

% test
u_int_rule = fem_domain_u.interior_domain_.intergation_rule_;
u_fs = fem_domain_u.interior_domain_.function_space_;

unit_id = 1;
int_unit = u_int_rule.integral_unit_data_{1};

u_fs.query(int_unit);

[n_q, xi, w] = int_unit.gauss_quadrature_();
n_q
xi
w

q_id = 1

[N, dN_dxi] = int_unit.evaluate_basis_(xi(q_id, :))
non_zero_id = int_unit.non_zero_id_




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

