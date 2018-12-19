function DemoIGA_3DLensGeometry

clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
%% Geometry data input
xml_path = './ArtPDE_IGA_3D_Lens_left.art_geometry';
geo{1} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_3D_Lens_right.art_geometry';
geo{2} = GeometryBuilder.create('IGA', 'XML', xml_path);

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis{1} = iga_domain.generateBasis(geo{1}.topology_data_{1});
nurbs_basis{2} = iga_domain.generateBasis(geo{2}.topology_data_{1});

%% Nurbs tools create
nurbs_tool{1} = NurbsTools(nurbs_basis{1});
nurbs_tool{2} = NurbsTools(nurbs_basis{2});

% Plot nurbs
figure; hold on; axis equal; grid on; view([30 25]);
nurbs_tool{1}.plotNurbs([21 21 21]);
nurbs_tool{2}.plotNurbs([21 21 21]);
hold off;

end

