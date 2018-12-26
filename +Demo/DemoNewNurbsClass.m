function DemoNewNurbsClass
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
%% Geometry data input
xml_path = './ArtPDE_IGA_3D_Lens_left.art_geometry';
% xml_path = './ArtPDE_IGA_Plane4_refined.art_geometry';
% xml_path = './ArtPDE_IGA_Plane_quarter_hole.art_geometry';

geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_data = geo.topology_data_{1}.domain_patch_data_.nurbs_data_;

nurbs_data.dispControlPoints();
nurbs_data.dispKnotVectors();
geo_dim = nurbs_data.getGeometryDimension();

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(geo.topology_data_{1});

%% Nurbs tools create
nurbs_tool = NurbsTools(nurbs_basis);

% Plot knot mesh in parametric space
figure; hold on; axis equal;
nurbs_tool.plotParametricMesh();
hold off;

% Plot nurbs
figure; hold on; grid on; %axis equal;
nurbs_tool.plotNurbs([21 21 21]);
nurbs_tool.plotControlMesh();
hold off;

% Evaluate nurbs & derivatives
xi = rand(5, geo_dim);

[position] = nurbs_tool.evaluateNurbs(xi, 'position');
[~, gradient] = nurbs_tool.evaluateNurbs(xi, 'gradient');
[position, gradient] = nurbs_tool.evaluateNurbs(xi, 'position', 'gradient');

 
end

