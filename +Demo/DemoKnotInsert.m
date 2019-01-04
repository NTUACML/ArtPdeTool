%function DemoKnotInsert
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.BasicUtility.*
import Utility.NurbsUtility.* 

% xml_path = './ArtPDE_IGA_Plane_quarter_hole.art_geometry';
% ArtPDE_IGA_3D_Lens_left;
xml_path = './ArtPDE_IGA_Plane4.art_geometry';

geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

domain_patch = nurbs_topology.getDomainPatch();
nurbs_data = domain_patch.nurbs_data_;

knots=nurbs_data.knot_vectors_
p=nurbs_data.order_
point=nurbs_data.control_points_
xi{1}=point(:,1)'
xi{2}=point(:,2)'
%xi{1}=[1,0,1,0]
%xi{2}=[0,1]
u={[1] [0]}
[new_points,new_knots]=Demo.Nurb_KnotIns( p, xi, knots, u)

%end