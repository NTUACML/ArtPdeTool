clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
fem_unit_cube_geo = GeometryBuilder.create('FEM', 'UnitCube_2_2_2');
iso_topo = fem_unit_cube_geo.topology_data_{1};

%% Domain create
fem_domain = DomainBuilder.create('FEM');

%% Basis create
fem_linear_basis = fem_domain.generateBasis(iso_topo);

%% Variable define   
var_t = fem_domain.generateVariable('temperature', fem_linear_basis,...
                                    VariableType.Scalar, 1);      
%% Test variable define
test_t = fem_domain.generateTestVariable(var_t, fem_linear_basis);

%% Set domain mapping - > physical domain to parametric domain
fem_domain.setMapping(fem_linear_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

%% Expression acquired
exp1 = operation1.getExpression('FEM', {test_t, var_t});

%% Integral variation equations
% Domain integral
int_doamin_patch = iso_topo.getDomainPatch();
fem_domain.calIntegral(int_doamin_patch, exp1);

%% Constraint (Acquire prescribed D.O.F.)
up_side_patch = iso_topo.getBoundayPatch('Up_Side');
down_side_patch = iso_topo.getBoundayPatch('Down_Side');
t_constraint_up = fem_domain.generateConstraint(up_side_patch, var_t, {1, @()1});
t_constraint_down = fem_domain.generateConstraint(down_side_patch, var_t, {1, @()0});
%% Solve domain equation system
fem_domain.solve('default');

%% Show result
disp(var_t);
