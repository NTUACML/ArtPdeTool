function DemoIGA_Laplace
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
% create nurbs tool box object
% srf = nrb4surf([0.0 0.0 0.0],[1.0 0.0 0.0],[0.0 1.0 0.0],[1.0 1.0 0.0]);
% srf = nrbdegelev(srf, [1 1]); 
% t = linspace(0.1, 0.9, 9);
% srf = nrbkntins(srf,{t, t}); 

% create geometry
% geo = GeometryBuilder.create('IGA', 'Nurbs_Object', srf);
% nurbs_topology = geo.topology_data_{1};

% create geometry
xml_path = './ArtPDE_IGA.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Variable define   
var_t = iga_domain.generateVariable('temperature', nurbs_basis,...
                                    VariableType.Scalar, 1);      
%% Test variable define
test_t = iga_domain.generateTestVariable(var_t, nurbs_basis);

%% Set domain mapping - > physical domain to parametric domain
iga_domain.setMapping(nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_t, var_t});

%% Integral variation equations
% Domain integral
int_doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(int_doamin_patch, exp1);

%% Constraint (Acquire prescribed D.O.F.)

%% Solve domain equation system
iga_domain.solve('default');

%% Show result
disp(var_t);
end
