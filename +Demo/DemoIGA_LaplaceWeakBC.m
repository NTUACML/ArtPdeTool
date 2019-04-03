function DemoIGA_LaplaceWeakBC
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Input geometry data
xml_path = './ArtPDE_IGA_Unit_Square.art_geometry';
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

%% Set domain mapping - > parametric domain to physical domain
iga_domain.setMapping(nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

operation2 = Operation();
operation2.setOperator('test_dot_var');

operation3 = Operation();
operation3.setOperator('test_dot_f');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_t, var_t});

beta = 1e6;
exp2 = operation2.getExpression('IGA', {test_t, var_t, beta});

unit_function = @(x, y) sin(pi*x);
exp3 = operation3.getExpression('IGA', {test_t, unit_function, beta});



%% Integral variation equations
% Domain integral
doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(doamin_patch, exp1);

% Boundary integration for imposing Dirichlet condition using penalty
% method
for patch_key = keys(nurbs_topology.boundary_patch_data_)
    bdr_patch = nurbs_topology.getBoundayPatch(patch_key{1});   
    
    iga_domain.calIntegral(bdr_patch, exp2);
end

bdr_patch = nurbs_topology.getBoundayPatch('eta_1');
iga_domain.calIntegral(bdr_patch, exp3);


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

patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
grid on;
title('ArtPDE Laplace problem... (IGA)')
view([40 30]);
%% Show result
%disp(var_t);
end
