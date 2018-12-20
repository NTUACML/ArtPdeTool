function DemoIGA_Laplace3D
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
xml_path = './ArtPDE_IGA_3D_Lens_left.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Nurbs tools create & plot nurbs
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; axis equal; grid on;
nurbs_tool.plotNurbs();
hold off;
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
doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(doamin_patch, exp1);

%% Constraint (Acquire prescribed D.O.F.)
bdr_patch = nurbs_topology.getBoundayPatch('xi_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('xi_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('eta_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('eta_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('zeta_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('zeta_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()1});


for key = keys(iga_domain.constraint_)
    constraint = iga_domain.constraint_(key{1});
    constraint.debugMode();
end

%% Solve domain equation system
iga_domain.solve('default');

%% Data Interpolation
import Interpolation.IGA.Interpolation;
t_interpo = Interpolation(var_t);
[x, data, element] = t_interpo.DomainDataSampling();

%% Show result (Post-Processes)
fv.vertices = [x, data];
fv.faces = element;
fv.facevertexcdata = data;
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
grid on;
title('ArtPDE Laplace problem... (IGA)')
view([40 30]);
%% Show result
%disp(var_t);
end
