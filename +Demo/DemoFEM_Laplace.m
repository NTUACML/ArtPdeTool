function DemoFEM_Laplace
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
fem_unit_cube_geo = GeometryBuilder.create('FEM', 'XML', './ArtPDE_FEM.art_geometry');
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

%% Data Interpolation
import Interpolation.FEM.Interpolation;
t_interpo = Interpolation(var_t);
[x, data, element] = t_interpo.NodeDataInterpolation();
% disp(var_t);

%% Show result (Post-Processes)
num_element = size(element, 1);
connectivity = zeros(num_element, 4);
for i = 1 : num_element
    connectivity(i, :) = element{i}.node_id_;
end
fv.vertices = [x, data];
fv.faces = connectivity;
fv.facevertexcdata = data;
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
grid on;
title('ArtPDE Laplace problem... (FEM)')
view([40 30]);
end
