function DemoIGA_LensGeometry
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.NurbsUtility.*

geo_container = cell(1,4);

xml_path = './ArtPDE_IGA_Lens_bottom_left.art_geometry';
geo_container{1} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Lens_bottom_right.art_geometry';
geo_container{2} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Lens_top_left.art_geometry';
geo_container{3} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Lens_top_right.art_geometry';
geo_container{4} = GeometryBuilder.create('IGA', 'XML', xml_path);

%% Domain create
iga_domain = DomainBuilder.create('IGA');

figure; hold all; view([0 90]); grid on; axis equal;
for geo = geo_container
    nurbs_topology = geo{1}.topology_data_{1};
    
    %% Basis create
    nurbs_basis = iga_domain.generateBasis(nurbs_topology);
    
    %% Nurbs tools
    nurbs_tool = NurbsTools(nurbs_basis);
   
    % plot nurbs surface & bounday nurbs
    nurbs_tool.plotNurbs([20 20]);
end
hold off;


end

