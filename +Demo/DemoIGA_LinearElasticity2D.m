function DemoIGA_LinearElasticity2D
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
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
xml_path = './ArtPDE_IGA_Beam_refined.art_geometry';
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

%% Set domain mapping - > physical domain to parametric domain
iga_domain.setMapping(nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('delta_epsilon_dot_sigma');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_u, var_u, constitutive_law});

%% Integral variation equations
% Domain integral
doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(doamin_patch, exp1);

%% Constraint (Acquire prescribed D.O.F.)
%% Exact solution for Cantilever Beam
geometry.D = 12.0;
geometry.L = 48.0;
geometry.p = 1000.0;

material.E = 3e7;
material.nu = 0.3;

outVal = 'displacement';
u_x = @(position) u_ana_x(position(:,1), position(:,2), material, geometry, outVal);
u_y = @(position) u_ana_y(position(:,1), position(:,2), material, geometry, outVal);

bdr_patch = nurbs_topology.getBoundayPatch('xi_0');
iga_domain.generateConstraint(bdr_patch, var_u, {1, u_x}, {'collocation', nurbs_basis});
iga_domain.generateConstraint(bdr_patch, var_u, {2, u_y}, {'collocation', nurbs_basis});

bdr_patch = nurbs_topology.getBoundayPatch('xi_1');
iga_domain.generateConstraint(bdr_patch, var_u, {1, u_x}, {'collocation', nurbs_basis});
iga_domain.generateConstraint(bdr_patch, var_u, {2, u_y}, {'collocation', nurbs_basis});

bdr_patch = nurbs_topology.getBoundayPatch('eta_0');
iga_domain.generateConstraint(bdr_patch, var_u, {1, u_x}, {'collocation', nurbs_basis});
iga_domain.generateConstraint(bdr_patch, var_u, {2, u_y}, {'collocation', nurbs_basis});

bdr_patch = nurbs_topology.getBoundayPatch('eta_1');
iga_domain.generateConstraint(bdr_patch, var_u, {1, u_x}, {'collocation', nurbs_basis});
iga_domain.generateConstraint(bdr_patch, var_u, {2, u_y}, {'collocation', nurbs_basis});

%% Nurbs tools create & plot nurbs
import Utility.NurbsUtility.NurbsTools
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; grid on; axis equal;
nurbs_tool.plotNurbs();
nurbs_tool.plotControlMesh();

control_point = doamin_patch.nurbs_data_.control_points_(:,1:3);
xlabel('x'); ylabel('y'); zlabel('z'); 
for i = 1:size(control_point,1)
    text(control_point(i,1), control_point(i,2), control_point(i,3), num2str(i), 'FontSize',14);
end

hold off;
%% Solve domain equation system
iga_domain.solve('default');

%% Data Interpolation
import Interpolation.IGA.Interpolation;
t_interpo = Interpolation(var_u);
[x, data, element] = t_interpo.DomainDataSampling();

%% Show result (Post-Processes)
fv.vertices = [x(:,1:2), data];
fv.faces = element;
fv.facevertexcdata = data;

figure; hold on; grid on; axis equal;
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('ArtPDE Laplace problem... (IGA)')
view([0 90]);
hold off;





%% Show result
% disp(var_u);
end

function val = u_ana_x(x, y, material, geometry, outVal)
    val = AnalyticSolutionElasticity(x, y, material, geometry, outVal);
    val= val.x;
end

function val = u_ana_y(x, y, material, geometry, outVal)
    val = AnalyticSolutionElasticity(x, y, material, geometry, outVal);
    val= val.y;
end

function val = AnalyticSolutionElasticity(x, y, material, geometry, outVal)
D = geometry.D;
L = geometry.L;
p = geometry.p;
E = material.E;
nu = material.nu;

I = D^3 / 12;

switch outVal
    case 'displacement'
        u.x = -(p*y / (6*E*I)) .* ((6*L-3*x).*x + (2+nu)*(y.^2 - D*D/4));
        u.y = (p / (6*E*I)) .* ( 3*nu*(L-x).*y.*y + (4+5*nu)*D*D*x/4 + (3*L-x).*x.*x );
        val = u;
    case 'stress'
        sigma.x = -p/I * (L-x).*y;
        sigma.y = 0;
        sigma.xy = p/(2*I) * (D*D/4 - y.^2);
        val = sigma;
end

end