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
point=nurbs_data.control_points_(:,:)
u={[0.25 0.7 0.9] [0.5 0.5 0.6]};
basis_num={nurbs_data.basis_number_(1) nurbs_data.basis_number_(2)}


% knots{1}=[0 0 0 1 1 1];
% knots{2}=[0 0 0 0.5 0.5 1 1 1];
% knots{3}=[0 0 0 0 1 1 1 1];
% point=[114.798929	0	-6.879260917	1;108.5685671	0	-8.01
% 0.995973632;102.2364285	0	-8.01	1;114.798929	-12.56250047	-6.879260917	0.707106781;108.5685671	-6.332138626	-8.01	0.704259709;102.2364285	0	-8.01	0.707106781;102.2364285	-12.56250047	-6.879260917	1;102.2364285	-6.332138626	-8.01	0.995973632;102.2364285	0	-8.01	1;89.67392803	-12.56250047	-6.879260917	0.707106781;5.90428987	-6.332138626	-8.01	0.704259709;102.2364285	0	-8.01	0.707106781;89.67392803	0	-6.879260917	1;95.90428987	0	-8.01	0.995973632;102.2364285	0	-8.01	1];
% p=[2,2,3]
% u={[0.5] [] []};

[new_points,new_knots]=Demo.Nurb_KnotIns( p, point, knots, u, basis_num) 


srf = nrb4surf([0 0 0 1],[0 1 0 1],[1 0 0 1],[1 1 0 1]) ;
test = nrbkntins(srf,{[0.5 0.5 0.6] [0.25 0.7 0.9]});
%end