% function DemoFEM_XMLfile
clc; clear; close all; home

%% Include package
import Geometry.*

%% Geometry data input
xml_path = './ArtPDE_IGA.art_geometry';
iga_geo = GeometryBuilder.create('IGA', 'XML', xml_path);
topo = iga_geo.topology_data_{1};

domain_nurbs = topo.getDomainPatch().nurbs_data_;
bdr_nurbs_1 = topo.getBoundayPatch('top').nurbs_data_;
bdr_nurbs_2 = topo.getBoundayPatch('bottom').nurbs_data_;
bdr_nurbs_3 = topo.getBoundayPatch('left').nurbs_data_;
bdr_nurbs_4 = topo.getBoundayPatch('right').nurbs_data_;

%% Print
disp(topo.point_data_)
disp(topo.getDomainPatch())
disp(topo.getBoundayPatch('top'))


% end
