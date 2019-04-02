function DemoIGA_Mapping
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.BasicUtility.*
import Utility.NurbsUtility.* 

xml_path = './ArtPDE_IGA_3D_Lens_left.art_geometry';

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


% 3D test
n = 4;
temp = linspace(0, 1, n);
[xx, yy] = meshgrid(temp, temp);
xx = xx(:);
yy = yy(:);

position = zeros(n, domain_patch.dim_);

for bdr_patch = values(boundary_patch_map)
    for i = 1:n^2
        s = [xx(i) yy(i)];    
        query_boundary.query_protocol_ = {bdr_patch{1}, s, 0};
        
        % get local mapping
        F = iga_domain.mapping_.queryLocalMapping(query_boundary);
        position(i,:) = F.calPhysicalPosition();
        normal = F.calNormalVector();
        normal = normal/ norm(normal);
        
        plot3(position(i,1), position(i,2), position(i,3), 'ro'); 
        quiver3(position(i,1), position(i,2), position(i,3), normal(1), normal(2), normal(3), 1.5, 'LineWidth', 2);
    end
%     plot(position(:,1), position(:,2), '-r', 'LineWidth', 2);
end



end
