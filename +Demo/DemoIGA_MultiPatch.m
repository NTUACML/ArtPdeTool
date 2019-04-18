function DemoIGA_MultiPatch
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.BasicUtility.*
import Utility.NurbsUtility.* 
import Operation.*

xml_path = './ArtPDE_IGA_Rectangle_bottom.art_geometry';
geo_1 = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Rectangle_top.art_geometry';
geo_2 = GeometryBuilder.create('IGA', 'XML', xml_path);

%% create topology map
topology_map = containers.Map('KeyType','char','ValueType','any');

topology_map('topo_1') = geo_1.topology_data_{1};
topology_map('topo_2') = geo_2.topology_data_{1};

%% Create Domain
iga_domain = DomainBuilder.create('IGA');

%% Create basis
basis_map = containers.Map('KeyType','char','ValueType','any');
for key = keys(topology_map)    
    basis_map(key{1}) = iga_domain.generateBasis(topology_map(key{1}));
end

%% Plot domain
figure; hold on; grid on; axis equal;
for basis = values(basis_map)       
    % Create Nurbs tools
    nurbs_tool = NurbsTools(basis{1});
    
    % Plot nurbs    
    nurbs_tool.plotNurbs([11 11]);
    nurbs_tool.plotControlMesh();
end
hold off;

%% Define variables   
u_1 = iga_domain.generateVariable('temperature_1', basis_map('topo_1'),...
                                    VariableType.Scalar, 1); 
u_2 = iga_domain.generateVariable('temperature_2', basis_map('topo_2'),...
                                    VariableType.Scalar, 1); 

%% Define test variable
v_1 = iga_domain.generateTestVariable(u_1, basis_map('topo_1'));
v_2 = iga_domain.generateTestVariable(u_2, basis_map('topo_2'));

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

operation2 = Operation();
operation2.setOperator('laplace_nitsche_dirichlet_lhs_term');

operation3 = Operation();
operation3.setOperator('laplace_nitsche_dirichlet_rhs_term');

operation4 = Operation();
operation4.setOperator('laplace_nitsche_interface_lhs_term');

% operation2 = Operation();
% operation2.setOperator('test_dot_var');
% 
% operation3 = Operation();
% operation3.setOperator('test_dot_f');


%% Set domain mapping - > parametric domain to physical domain
mapping_map = containers.Map('KeyType','char','ValueType','any');

import Mapping.IGA.Mapping
mapping_map('topo_1') = Mapping(basis_map('topo_1'));
mapping_map('topo_2') = Mapping(basis_map('topo_2'));

%% Integral variation equations
% penalty parameter
beta = 1e2;

% Interface integral
exp = operation4.getExpression('IGA', {v_1, u_1, v_2, u_2, beta});

import Utility.BasicUtility.InterfacePatch
master_patch = topology_map('topo_1').getBoundayPatch('eta_1');
slave_patch = topology_map('topo_2').getBoundayPatch('eta_0');

interface_patch = InterfacePatch(master_patch, slave_patch);
iga_domain.calIntegral(interface_patch, exp, {mapping_map('topo_1'), mapping_map('topo_2')});

% Domain integral
doamin_patch = topology_map('topo_1').getDomainPatch();
exp = operation1.getExpression('IGA', {v_1, u_1});
iga_domain.calIntegral(doamin_patch, exp, mapping_map('topo_1'));

doamin_patch = topology_map('topo_2').getDomainPatch();
exp = operation1.getExpression('IGA', {v_2, u_2});
iga_domain.calIntegral(doamin_patch, exp, mapping_map('topo_2'));

% Boundary integral for Dirichlet boundary using the Nitsche's method
% topology 1
exp = operation2.getExpression('IGA', {v_1, u_1, beta});

bdr_patch = topology_map('topo_1').getBoundayPatch('xi_0');
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_1'));

bdr_patch = topology_map('topo_1').getBoundayPatch('xi_1');
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_1'));

bdr_patch = topology_map('topo_1').getBoundayPatch('eta_0');
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_1'));

% topology 2
exp = operation2.getExpression('IGA', {v_2, u_2, beta});

bdr_patch = topology_map('topo_2').getBoundayPatch('xi_0');
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_2'));

bdr_patch = topology_map('topo_2').getBoundayPatch('xi_1');
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_2'));

bdr_patch = topology_map('topo_2').getBoundayPatch('eta_1');
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_2'));

boudary_function = @(x, y) sin(pi*x);
exp = operation3.getExpression('IGA', {v_2, boudary_function, beta});
iga_domain.calIntegral(bdr_patch, exp, mapping_map('topo_2'));

%% Solve domain equation system
iga_domain.solve('default');

%% Data Interpolation
import Interpolation.IGA.Interpolation;
u_interpo_1 = Interpolation(u_1);
[x, data, element] = u_interpo_1.DomainDataSampling();

%% Show result (Post-Processes)
fv.vertices = [x(:,1:2), data.value{1}];
fv.faces = element;
fv.facevertexcdata = data.value{1};

figure; hold on; grid on; view([0 0]);
title('ArtPDE Laplace problem... (IGA)')

patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);

u_interpo_2 = Interpolation(u_2);
[x, data, element] = u_interpo_2.DomainDataSampling();

%% Show result (Post-Processes)
fv.vertices = [x(:,1:2), data.value{1}];
fv.faces = element;
fv.facevertexcdata = data.value{1};

patch(fv,'CDataMapping','scaled','EdgeColor',[.7 .7 .7],'FaceColor','interp','FaceAlpha',1);

end
