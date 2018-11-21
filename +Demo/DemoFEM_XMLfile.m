% function DemoFEM_XMLfile
clc; clear; close all; home

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
xml_path = './ArtPDE_FEM.art_geometry';
fem_geo = GeometryBuilder.create('FEM', 'XML', xml_path);
iso_topo = fem_geo.topology_data_{1};

% %% Print
% disp(iso_topo.point_data_)
% disp(iso_topo.getDomainPatch())
% disp(iso_topo.getBoundayPatch('up'))
% disp(iso_topo.getBoundayPatch('down'))
% disp(iso_topo.getBoundayPatch('left'))
% disp(iso_topo.getBoundayPatch('right'))
% % end

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
up_side_patch = iso_topo.getBoundayPatch('up');
down_side_patch = iso_topo.getBoundayPatch('down');
left_side_patch = iso_topo.getBoundayPatch('left');
right_side_patch = iso_topo.getBoundayPatch('right');
t_constraint_up = fem_domain.generateConstraint(up_side_patch, var_t, {1, @()1});
t_constraint_down = fem_domain.generateConstraint(down_side_patch, var_t, {1, @()0});
t_constraint_left = fem_domain.generateConstraint(left_side_patch, var_t, {1, @()0});
t_constraint_right = fem_domain.generateConstraint(right_side_patch, var_t, {1, @()0});
%% Solve domain equation system
fem_domain.solve('default');

%% Show result
disp(var_t);