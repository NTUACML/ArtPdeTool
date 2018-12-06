function DemoIGALensGeometry
clc; clear; close all;

%% create Geometry
import Geometry.* 

geo_container = cell(1,4);

xml_path = './ArtPDE_IGA_Lens_bottom_left.art_geometry';
geo_container{1} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Lens_bottom_right.art_geometry';
geo_container{2} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Lens_top_left.art_geometry';
geo_container{3} = GeometryBuilder.create('IGA', 'XML', xml_path);

xml_path = './ArtPDE_IGA_Lens_top_right.art_geometry';
geo_container{4} = GeometryBuilder.create('IGA', 'XML', xml_path);

figure; hold all; view([0 90]); grid on; axis equal;
for geo = geo_container
    nurbs_topology = geo{1}.topology_data_{1};
    domain_patch = nurbs_topology.getDomainPatch();
    nurbs_data = domain_patch.nurbs_data_;
    
%     t_1 = linspace(0,1,5); t_1 = t_1(2:end-1);
%     t_2 = t_1; bool = abs(t_2-0.5) < eps; t_2 = t_2(~bool);
%     nurbs_data.knotInsertion({t_1 t_2});
    
    % plot nurbs surface & bounday nurbs 
    nurbs_data.plotNurbsSurface({[20 20] 'plotKnotMesh'});
    
%     for patch_key = keys(nurbs_topology.boundary_patch_data_)
%         patch = nurbs_topology.getBoundayPatch(patch_key{1});
%         pnt = patch.nurbs_data_.control_points_(:,1:2);
%         pnt = [linspace(pnt(1,1), pnt(end,1), 21)' linspace(pnt(1,2), pnt(end,2), 21)'];
%         
%         position = domain_patch.nurbs_data_.evaluateNurbs(pnt);
%         plot3(position(:,1), position(:,2), position(:,3), 'LineWidth', 1.5);
%     end
end
hold off;


end

