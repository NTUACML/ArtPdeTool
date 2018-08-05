clc; clear; close all;

%% Include package
import Domain.*
import FunctionSpace.*

%% Domain
% mesh_type_domain = DomainBuilder.create('Mesh', 'UnitCube');

%% Function Space
% import Utility.BasicUtility.Order

% function_space = FunctionSpaceBuilder.create('FEM', mesh_type_domain); % default(Linear)
% function_space = FunctionSpaceBuilder.create('FEM', mesh_type_domain, {Order.Linear});

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


% %% RKPM Domain & Function Space test
% 
% %% Domain
% point_type_domain = DomainBuilder.create('ScatterPoint', 'StraightLine');
% % point_type_domain = DomainBuilder.create('ScatterPoint', 'UnitSquare');
% 
% %% Function Space
% support_size_ratio = 1.5;
% function_space = FunctionSpaceBuilder.create('RKPM', point_type_domain, Order.Quadratic, support_size_ratio); % default(Linear, support_size_ratio = 1.5)
% 
% %% Function Space (Query - Preprocess)
% import FunctionSpace.QueryUnit.RKPM.QueryUnitRKPM
% 
% fs_query_unit = QueryUnitRKPM();
% disp( '>* querying : position is 0.05');
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

%% Test
import Utility.BasicUtility.*
% Initial input matrix
input_mat = [1 2 3; 4 5 6; 7 8 9; 10 11 12; 13 14 15];
% Create PointList
point_list = PointList(input_mat);
% Display all the data in PointList
disp(point_list)
% Slicing sub-matrix for the point list
mat_point = point_list(1:2:5,1:2);
% Slicing points cell data for the point list
cell_point = point_list{1:2:5};

