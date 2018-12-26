function DemoIGA_Constraint
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
% xml_path = './ArtPDE_IGA_Plane4_refined.art_geometry';
% xml_path = './ArtPDE_IGA_Plane_quarter_hole.art_geometry'; ArtPDE_IGA_Lens_top_left
xml_path = './ArtPDE_IGA_Lens_bottom_left.art_geometry';

geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Variable define   
var_t = iga_domain.generateVariable('temperature', nurbs_basis,...
                                    VariableType.Scalar, 1);

%% Constraint (Acquire prescribed D.O.F.)
bdr_patch = nurbs_topology.getBoundayPatch('xi_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('xi_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('eta_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('eta_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()1});

doamin_patch = nurbs_topology.getDomainPatch();

%% Nurbs tools create & plot nurbs
import Utility.NurbsUtility.NurbsTools
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; grid on; %axis equal;
nurbs_tool.plotNurbs();
nurbs_tool.plotControlMesh();

control_point = doamin_patch.nurbs_data_.control_points_(:,1:3);
xlabel('x'); ylabel('y'); zlabel('z'); 
for i = 1:size(control_point,1)
    text(control_point(i,1), control_point(i,2), control_point(i,3), num2str(i), 'FontSize',14);
end


for key = keys(iga_domain.constraint_)
    constraint = iga_domain.constraint_(key{1});
    constraint.debugMode();
    
    id = constraint.constraint_var_id_';
    pt = control_point(id,:);
    plot3(pt(:,1), pt(:,2), pt(:,3), 'r.', 'MarkerSize', 20)
end

hold off;

end

