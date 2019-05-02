function DemoIGA_LaplaceNitsche
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Input geometry data
xml_path = './ArtPDE_IGA_Rectangle.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Ceate domain
iga_domain = DomainBuilder.create('IGA');

%% Create basis 
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Plot domain
nurbs_tool = NurbsTools(nurbs_basis); 
figure; hold on; grid on; axis equal;
nurbs_tool.plotNurbs(); 
nurbs_tool.plotControlMesh();
hold off;

%% Define variable   
var_t = iga_domain.generateVariable('temperature', nurbs_basis,...
                                    VariableType.Scalar, 1);      
%% Define test variable
test_t = iga_domain.generateTestVariable(var_t, nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

operation2 = Operation();
operation2.setOperator('laplace_nitsche_dirichlet_lhs_term');

operation3 = Operation();
operation3.setOperator('laplace_nitsche_dirichlet_rhs_term');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_t, var_t});

beta = 1e2;
exp2 = operation2.getExpression('IGA', {test_t, var_t, beta});

boudary_function = @(x, y) sin(pi*x);
exp3 = operation3.getExpression('IGA', {test_t, boudary_function, beta});

%% Integral variation equations
import Differential.IGA.*

% Domain integral
domain_patch = nurbs_topology.getDomainPatch();
dOmega = Differential(nurbs_basis, domain_patch);

iga_domain.integrate(exp1, dOmega);

% Boundary integration for imposing Dirichlet condition using penalty
% method
for patch_key = keys(nurbs_topology.boundary_patch_data_)
    bdr_patch = nurbs_topology.getBoundayPatch(patch_key{1});       
    dGamma = Differential(nurbs_basis, bdr_patch);

    iga_domain.integrate(exp2, dGamma);
end

bdr_patch = nurbs_topology.getBoundayPatch('eta_1');
dGamma = Differential(nurbs_basis, bdr_patch);

iga_domain.integrate(exp3, dGamma);


%% Solve domain equation system
iga_domain.solve('default');

%% Data Interpolation
import Interpolation.IGA.Interpolation;
t_interpo = Interpolation(var_t);
[x, data, element] = t_interpo.DomainDataSampling();

%% Show result (Post-Processes)
fv.vertices = [x(:,1:2), data.value{1}];
fv.faces = element;
fv.facevertexcdata = data.value{1};

figure;
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
grid on;
title('ArtPDE Laplace problem... (IGA)')
view([40 30]);
%% Show result
%disp(var_t);
end
