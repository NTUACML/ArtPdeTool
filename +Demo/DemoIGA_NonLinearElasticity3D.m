function DemoIGA_NonLinearElasticity3D
clc; clear; close all;
%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*
import Interpolation.IGA.Interpolation

%% Geometry data input
xml_path = './ArtPDE_IGA_Unit_Cube.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Nurbs tools create & plot nurbs
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; grid on; view([120 30]);
nurbs_tool.plotNurbs();

control_point = nurbs_topology.domain_patch_data_.nurbs_data_.control_points_(:,1:3);
xlabel('x'); ylabel('y'); zlabel('z'); 
for i = 1:size(control_point,1)
    text(control_point(i,1), control_point(i,2), control_point(i,3), num2str(i), 'FontSize',14);
end

hold off;

%% Variable define   
u = iga_domain.generateVariable('displacement', nurbs_basis,...
                                    VariableType.Vector, 3);                               
%% Test variable define
v = iga_domain.generateTestVariable(u, nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('nonlinear_elasticity_lhs');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {v, u, 'Mooney'});

%% Integral variation equations
% Domain integral
import Differential.IGA.*

% Domain integral
domain_patch = nurbs_topology.getDomainPatch();
dOmega = Differential(nurbs_basis, domain_patch);

iga_domain.integrate(exp1, dOmega);

%% Constraint (Acquire prescribed D.O.F.)
bdr_patch = nurbs_topology.getBoundayPatch('xi_0');
iga_domain.generateConstraint(bdr_patch, u, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('xi_1');
iga_domain.generateConstraint(bdr_patch, u, {1, @()5});

bdr_patch = nurbs_topology.getBoundayPatch('eta_0');
iga_domain.generateConstraint(bdr_patch, u, {2, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('zeta_0');
iga_domain.generateConstraint(bdr_patch, u, {3, @()0});

%% Solve domain equation system
import Solver.*
import Utility.BasicUtility.SolverType
solver = Solver();

tolerance = 1e-6;
total_load_steps = 10;

solver.generate(iga_domain, SolverType.NonlinearNewton, {tolerance, total_load_steps});
solver.solve();

%% Data Interpolation
t_interpo = Interpolation(u);
[x, data, element] = t_interpo.DomainDataSampling(11, 'gradient');

%% Show result (Post-Processes)
% plot x-displacement
fv.vertices = [x(:,1:2), data.value{1}];
fv.faces = element;
fv.facevertexcdata = data.value{1};

figure; hold on; grid on; view([20 30]);
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('IGA Cantilever Beam x-displacement')
view([20 30]);
hold off;

% plot y-displacement
fv.vertices = [x(:,1:2), data.value{2}];
fv.faces = element;
fv.facevertexcdata = data.value{2};

figure; hold on; grid on; view([20 30]);
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('IGA Cantilever Beam y-displacement')
view([20 30]);
hold off;

% plot deformed mesh
import Utility.Resources.quadplot
figure; hold on; grid on; axis equal;
quadplot(element, x(:,1)+data.value{1}, x(:,2)+data.value{2});
title('IGA Cantilever Beam deformed mesh')
hold off;

%% Show result
% disp(var_u);
end

