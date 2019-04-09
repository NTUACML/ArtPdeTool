function DemoIGA_MultiPatch
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.BasicUtility.*
import Utility.NurbsUtility.* 

xml_path = './ArtPDE_IGA_Plane_quarter_hole.art_geometry';
geo_1 = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Plane_quarter_hole_2.art_geometry';
geo_2 = GeometryBuilder.create('IGA', 'XML', xml_path);

%% create topology map
topology_map = containers.Map('KeyType','char','ValueType','any');

topology_map('topo_1') = geo_1.topology_data_{1};
topology_map('topo_2') = geo_2.topology_data_{1};

% create interface patch
% boundary_patch_1 = topology_map('topo_1').boundary_patch_data_('xi_0');
% boundary_patch_2 = topology_map('topo_2').boundary_patch_data_('xi_1');
% topology_map('interface') = createInterfaceTopology(boundary_patch_1, boundary_patch_2);


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
    nurbs_tool.plotNurbs([21 21 21]);
%     nurbs_tool.plotControlMesh();
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


%% Set domain mapping - > parametric domain to physical domain
mapping_map = containers.Map('KeyType','char','ValueType','any');

import Mapping.IGA.Mapping
mapping_map('topo_1') = Mapping(basis_map('topo_1'));
mapping_map('topo_2') = Mapping(basis_map('topo_2'));

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
% Domain integral
doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(doamin_patch, exp1, mapping_map('topo_1'));

% domain_patch = nurbs_topology.domain_patch_data_;
% boundary_patch_map = nurbs_topology.boundary_patch_data_;


end

% function interface_topology = createInterfaceTopology(boundary_patch_1, boundary_patch_2)
% import Geometry.Topology.NurbsTopology
% interface_topology = NurbsTopology(2);
% 
% interface_topology.domain_patch_data_ = [];
% interface_topology.boundary_patch_data_()
% end