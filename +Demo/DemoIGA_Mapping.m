function DemoIGA_Mapping
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.BasicUtility.*
import Utility.NurbsUtility.* 

xml_path = './ArtPDE_IGA_Plane_quarter_hole.art_geometry';

geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

domain_patch = nurbs_topology.domain_patch_data_;
boundary_patch_map = nurbs_topology.boundary_patch_data_;
%% Create Domain
iga_domain = DomainBuilder.create('IGA');

%% Create Basis
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Create Nurbs tools
nurbs_tool = NurbsTools(nurbs_basis);

% Plot nurbs
figure; hold on; grid on; axis equal;
nurbs_tool.plotNurbs([21 21 21]); 
% nurbs_tool.plotControlMesh();


%% Set domain mapping - > parametric domain to physical domain
iga_domain.setMapping(nurbs_basis);

% plor nurbs boundary patch
import BasisFunction.IGA.QueryUnit
query_boundary = QueryUnit();


n = 6;
temp = linspace(0, 1, n);
position = zeros(n, 2);

for bdr_patch = values(boundary_patch_map)
    for i = 1:n
        s = temp(i);    
        query_boundary.query_protocol_ = {bdr_patch{1}, s, 0};
        
        % get local mapping
        F = iga_domain.mapping_.queryLocalMapping(query_boundary);
        position(i,:) = F.calPhysicalPosition();
        normal = F.calNormalVector();
        normal = normal/ norm(normal);
        
        plot(position(i,1), position(i,2), 'ro'); 
        quiver(position(i,1), position(i,2), normal(1), normal(2), 'LineWidth', 2);
    end
%     plot(position(:,1), position(:,2), '-r', 'LineWidth', 2);
end



end
