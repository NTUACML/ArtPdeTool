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
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*
import Interpolation.IGA.Interpolation

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
iga_domain.calIntegral(doamin_patch, exp1, {'Default', 3});

%% Constraint (Acquire prescribed D.O.F.)
%% Exact solution for Cantilever Beam
geometry.D = 2.0;
geometry.L = 20.0;
geometry.p = -1.0;

material.E = E;
material.nu = nu;

u_x = @(position) u_ana_x(position(:,1), position(:,2), material, geometry);
u_y = @(position) u_ana_y(position(:,1), position(:,2), material, geometry);

sigma_x = @(position) sigma_ana_x(position(:,1), position(:,2), material, geometry);
sigma_y = @(position) sigma_ana_y(position(:,1), position(:,2), material, geometry);
sigma_xy = @(position) sigma_ana_xy(position(:,1), position(:,2), material, geometry);

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
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; grid on; 
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

ana = u_x(x(:,1:2));
plot3(x(:,1), x(:,2), ana, 'r.');
rms_ = rms(data.value{1}-ana);
disp(rms_);
hold off;

% plot y-displacement
fv.vertices = [x(:,1:2), data.value{2}];
fv.faces = element;
fv.facevertexcdata = data.value{2};

figure; hold on; grid on; view([20 30]);
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('IGA Cantilever Beam y-displacement')
view([20 30]);

ana = u_y(x(:,1:2));
plot3(x(:,1), x(:,2), ana, 'r.');
rms_ = rms(data.value{2}-ana);
disp(rms_);
hold off;

% plot deformed mesh
import Utility.Resources.quadplot
figure; hold on; grid on; axis equal;
scale_factor = 50;
quadplot(element, x(:,1)+scale_factor*data.value{1}, x(:,2)+scale_factor*data.value{2});
title('IGA Cantilever Beam deformed mesh')
hold off;


temp = E/(1-nu*nu);
% plot sigma_x
s_x = (data.gradient{1,1} + nu*data.gradient{2,2})*temp;

fv.vertices = [x(:,1:2), s_x];
fv.faces = element;
fv.facevertexcdata = s_x;

figure; hold on; grid on; view([20 30]);
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('IGA Cantilever Beam \sigma_x')
view([20 30]);

ana = sigma_x(x(:,1:2));
plot3(x(:,1), x(:,2), ana, 'r.');
rms_ = rms(s_x-ana);
disp(rms_);
hold off;

% plot sigma_y
s_y = (nu*data.gradient{1,1} + data.gradient{2,2})*temp;

fv.vertices = [x(:,1:2), s_y];
fv.faces = element;
fv.facevertexcdata = s_y;

figure; hold on; grid on; view([20 30]);
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('IGA Cantilever Beam \sigma_y')
view([20 30]);

ana = sigma_y(x(:,1:2));
plot3(x(:,1), x(:,2), ana, 'r.');
rms_ = rms(s_y-ana);
disp(rms_);
hold off;

% plot sigma_xy
s_xy = (data.gradient{1,2} + data.gradient{2,1})*temp*0.5*(1-nu);

fv.vertices = [x(:,1:2), s_xy];
fv.faces = element;
fv.facevertexcdata = s_xy;

figure; hold on; grid on; 
patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);
title('IGA Cantilever Beam \sigma_{xy}')
view([20 30]);

ana = sigma_xy(x(:,1:2));
plot3(x(:,1), x(:,2), ana, 'r.');
rms_ = rms(s_xy-ana);
disp(rms_);
hold off;

%% Show result
% disp(var_u);
end

function val = u_ana_x(x, y, material, geometry)
    val = AnalyticSolutionElasticity(x, y, material, geometry, 'displacement');
    val= val.x;
end

function val = u_ana_y(x, y, material, geometry)
    val = AnalyticSolutionElasticity(x, y, material, geometry, 'displacement');
    val= val.y;
end

function val = sigma_ana_x(x, y, material, geometry)
    val = AnalyticSolutionElasticity(x, y, material, geometry, 'stress');
    val= val.x;
end

function val = sigma_ana_y(x, y, material, geometry)
    val = AnalyticSolutionElasticity(x, y, material, geometry, 'stress');
    val= val.y;
end

function val = sigma_ana_xy(x, y, material, geometry)
    val = AnalyticSolutionElasticity(x, y, material, geometry, 'stress');
    val= val.xy;
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
        sigma.y = zeros(size(x));
        sigma.xy = p/(2*I) * (D*D/4 - y.^2);
        val = sigma;
end

end