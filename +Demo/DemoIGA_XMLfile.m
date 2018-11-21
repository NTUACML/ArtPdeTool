% function DemoFEM_XMLfile
clc; clear; close all; home

%% Include package
import Geometry.*

%% Geometry data input
xml_path = './ArtPDE_IGA.art_geometry';
iga_geo = GeometryBuilder.create('IGA', 'XML', xml_path);
% iso_topo = fem_geo.topology_data_{1};
% 
% %% Print
% disp(iso_topo.point_data_)
% disp(iso_topo.getDomainPatch())
% disp(iso_topo.getBoundayPatch('top'))


% end
