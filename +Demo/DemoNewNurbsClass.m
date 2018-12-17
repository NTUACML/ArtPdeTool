function DemoNewNurbsClass
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*
%% Geometry data input
xml_path = './ArtPDE_IGA_3D_Lens.art_geometry';
% xml_path = './ArtPDE_IGA_Plane4_refined.art_geometry';

geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_data = geo.topology_data_{1}.domain_patch_data_.nurbs_data_;

nurbs_data.dispControlPoints();
nurbs_data.dispKnotVectors();
geo_dim = nurbs_data.getGeometryDimension();

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(geo.topology_data_{1});

%% Nurbs tools
nurbs_tool = NurbsTools(nurbs_basis);

% Plot knot mesh
figure; hold on; axis equal;
nurbs_tool.plotParametricMesh();
hold off;

end

