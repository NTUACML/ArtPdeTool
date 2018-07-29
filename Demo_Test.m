clc; clear; close all;

%% Include package
import Domain.*
import FunctionSpace.*

%% Domain
domain = DomainBuilder.create('Mesh', 'UnitCube');

%% Function Space
import Utility.BasicUtility.Order

% function_space = FunctionSpaceBuilder.create('FEM', domain); % default(Linear)
function_space = FunctionSpaceBuilder.create('FEM', domain, {Order.Linear});

%% Function Space (Query - Preprocess)
import FunctionSpace.QueryUnit.FEM.QueryUnit
import Utility.BasicUtility.Region
import Utility.BasicUtility.Procedure

fs_query_unit = QueryUnit();
disp( '>* querying : interior domain, element - 1, parametric position is [0, 0, 0]');
fs_query_unit.setQuery(Region.Interior, 1, [0, 0, 0]);
[non_zeros_id, ~] = function_space.query(fs_query_unit, Procedure.Preprocess);
disp('Non_zeros_id : ');
disp(non_zeros_id);

%% Function Space (Query - Runtime)
import FunctionSpace.QueryUnit.FEM.QueryUnit
import Utility.BasicUtility.Region
import Utility.BasicUtility.Procedure

fs_query_unit = QueryUnit();
disp( '>* querying : boundary domain, element - 2, parametric position is [-1, 1, 0]')
fs_query_unit.setQuery(Region.Boundary, 2, [-1, 1, 0]);
[~, basis_value] = function_space.query(fs_query_unit); %default(Runtime)
N = basis_value{1};
dN_dxi = basis_value{2};
disp('N :');
disp(N);
disp('dN_dxi :');
disp(dN_dxi);