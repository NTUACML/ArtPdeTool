function DemoNewNurbsClass
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
%% Geometry data input
% ArtPDE_IGA_3D_Lens_left  ArtPDE_IGA_Plane4_refined ArtPDE_IGA_Hexa_quarter_hole
% ArtPDE_IGA_Plane_quarter_hole ArtPDE_IGA_Lens_bottom_left
xml_path = './ArtPDE_IGA_Hexa_quarter_hole.art_geometry';

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

% generate 5 random parametric point
xi = rand(5, geo_dim);

% Plot nurbs
figure; hold on; grid on; axis equal;
nurbs_tool.plotNurbs([21 21 21]); view([50 30]);
nurbs_tool.plotControlMesh();
hold off;

% Evaluate nurbs & derivatives
% [position_org, gradient_org] = nurbs_tool.evaluateNurbs(xi, 'position', 'gradient');

%% Knot insert
% nurbs_tool.degreeElevation([1 0]);
% nurbs_tool.knotInsertion({[0.2 0.8] [0.3 0.7]});

% nurbs_tool.degreeElevation([1 0 0]);
nurbs_tool.knotInsertion({[0.2 0.8] [0.3 0.7] [0.4 0.9]});

nurbs_data.dispControlPoints();
nurbs_data.dispKnotVectors();

% Plot knot mesh in parametric space
figure; hold on; axis equal; view([-30 30]);
nurbs_tool.plotParametricMesh();
hold off;

% Plot nurbs
figure; hold on; grid on; axis equal;
nurbs_tool.plotNurbs([15 15 15]); view([50 30]);
nurbs_tool.plotControlMesh();
hold off;

% Evaluate nurbs & derivatives
% [position_new, gradient_new] = nurbs_tool.evaluateNurbs(xi, 'position', 'gradient');


% [position] = nurbs_tool.evaluateNurbs(xi, 'position');
% [~, gradient] = nurbs_tool.evaluateNurbs(xi, 'gradient');
% [position, gradient] = nurbs_tool.evaluateNurbs(xi, 'position', 'gradient');

 
end

