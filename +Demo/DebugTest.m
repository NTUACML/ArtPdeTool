clc; clear; close all;

%% create Geometry
import Geometry.*

height = 3;
radius = 1;
center = [];
sang = deg2rad(0);      % start angle
eang = deg2rad(360);    % end angle

geo = GeometryBuilder.create('IGA', 'CylinderSurface', {height, radius, center, sang, eang});
nurbs_topology = geo.topology_data_{1};
nurbs_data = nurbs_topology.domain_patch_data_.nurbs_data_;
% nurbs_data.debug();
nurbs_data.degreeElevation([0 1]);
% nurbs_data.debug();
nurbs_data.knotInsertion({[0.1], [0.125 0.375 0.625 0.875]});