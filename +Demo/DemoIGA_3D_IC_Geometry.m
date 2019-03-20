function DemoIGA_3D_IC_Geometry

clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
%% Geometry data input
xml_path = './ArtPDE_IGA_Solid_quarter_hole.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);

%% Domain create
iga_domain = DomainBuilder.create('IGA');

nurbs_data = geo.topology_data_{1}.domain_patch_data_.nurbs_data_;

%% Basis create
nurbs_basis = iga_domain.generateBasis(geo.topology_data_{1});

%% Nurbs tools create
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold all; grid on;
nurbs_tool.plotParametricMesh();

for val = values(geo.topology_data_{1}.boundary_patch_data_)
    disp(val{1}.name_);
    nurbs_data = val{1}.nurbs_data_;
    plot3(nurbs_data.control_points_(:,1), nurbs_data.control_points_(:,2), nurbs_data.control_points_(:,3), '.', 'MarkerSize', 24);
end
hold off;

% nurbs_tool.degreeElevation([1 1 1]);
% nurbs_tool.knotInsertion({[0.1 0.9] [0.5] [0.5]});
% Plot nurbs
figure; hold on; axis equal; grid on; view([30 25]);
nurbs_tool.plotNurbs([15 15 4]);
% nurbs_tool.plotControlMesh();

theta = pi/2;
Rotation = [cos(theta) -sin(theta) 0;
            sin(theta) cos(theta) 0;
            0 0 1];

for k = 1:3
    for i = 1:prod(nurbs_data.basis_number_)
        nurbs_data.control_points_(i,1:3) = nurbs_data.control_points_(i,1:3)*Rotation';
    end
    nurbs_tool.plotNurbs([15 15 4]);
%     nurbs_tool.plotControlMesh();
end
       
hold off;


end

