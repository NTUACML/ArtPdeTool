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
Surf=nurbs_data;

%linear demo
Line.order_=[2];
Line.knot_vectors_={[0,0,0,0.25,0.5,0.75,0.75,1,1,1]};
Line.control_points_=[0.5,1.5,4.5,3,7.5,6,8.5;3,5.5,5.5,1.5,1.5,4,4.5;0,0,0,0,0,0,0;1,1,1,1,1,1,1]';
Line.basis_number_=[7];

%3D Test
Test3D.knot_vectors_{1}=[0 0 1 1];
Test3D.knot_vectors_{2}=[0 0 1 1];
Test3D.knot_vectors_{3}=[0 0 1 1];
Test3D.control_points_=[0 0 0 1;1 0 0 1;0 1 0 1;1 1 0 1;0 0 1 1;1 0 1 1;0 1 1 1;1 1 1 1];
Test3D.order_=[1,1,1];
Test3D.basis_number_=[2,2,2];

%Line / Surf / Test3D
[new_point,new_knots]=Demo.Nurb_KnotIns(Test3D,{[0.25] [0.6] [0.8 0.8]}) 

%Example
crv = nrbtestcrv; 
icrv = nrbkntins(crv,[0.375 0.5]);

srf = nrb4surf([0 0 0 1],[0 1 0 1],[1 0 0 1],[1 1 0 1]) ;
isrf = nrbkntins(srf,{[0.375 0.5] [0.6 0.6]});

% iga_domain = DomainBuilder.create('IGA');
% nurbs_basis = iga_domain.generateBasis(geo.topology_data_{1})
% nurbs_tool = NurbsTools(nurbs_basis)
% nurbs_tool.plotControlMesh();

%end