function DemoIGA_ThermoElasticity2D
clc; clear; close all;

E = 1e5;
nu = 0.3;
% Plane stress
temp = E/(1-nu*nu);
constitutive_law = temp*[1  nu 0;
                         nu 1  0;
                         0  0  0.5*(1-nu)];
% Plane strain                     
% temp = E/(1+nu)/(1-2*nu);
% constitutive_law = temp*[1-nu nu   0;
%                          nu   1-nu 0;
%                          0    0    0.5*(1-2*nu)];

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*
import Interpolation.IGA.Interpolation

%% Geometry data input
xml_path = './ArtPDE_IGA_Rectangle.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Variable define   
var_u = iga_domain.generateVariable('displacement', nurbs_basis,...
                                    VariableType.Vector, 2);      
%% Test variable define
test_u = iga_domain.generateTestVariable(var_u, nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('delta_epsilon_dot_sigma');

operation2 = Operation();
operation2.setOperator('delta_Tr(epsilon)_T');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_u, var_u, constitutive_law});

% thermal function = beta * Delta T
thermal_function = @(x, y) 100;
exp2 = operation2.getExpression('IGA', {test_u, thermal_function});

%% Integral variation equations
% Domain integral
import Differential.IGA.*

domain_patch = nurbs_topology.getDomainPatch();
dOmega = Differential(nurbs_basis, domain_patch);

iga_domain.integrate(exp1, dOmega, {'Default', 3});
iga_domain.integrate(exp2, dOmega, {'Default', 3});

%% Constraint (Acquire prescribed D.O.F.)
zero_function = @(position) 0;

bdr_patch = nurbs_topology.getBoundayPatch('xi_0');
iga_domain.generateConstraint(bdr_patch, var_u, {1, zero_function}, {'collocation', nurbs_basis});

bdr_patch = nurbs_topology.getBoundayPatch('eta_0');
iga_domain.generateConstraint(bdr_patch, var_u, {2, zero_function}, {'collocation', nurbs_basis});

%% Nurbs tools create & plot nurbs
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; grid on; 
nurbs_tool.plotNurbs();
nurbs_tool.plotControlMesh();

hold off;
%% Solve domain equation system
iga_domain.solve('default');

%% Data Interpolation
t_interpo = Interpolation(var_u);
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
scale_factor = 100;
quadplot(element, x(:,1), x(:,2), 'b-');
quadplot(element, x(:,1)+scale_factor*data.value{1}, x(:,2)+scale_factor*data.value{2}, 'k-');
title('IGA Cantilever Beam deformed mesh')
hold off;


end
