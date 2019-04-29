function DemoIGA_Differential
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
import Differential.IGA.*
dOmega = Differential(nurbs_basis, domain_patch);

xi_org = [0.2333876 0.13384755];
dOmega.queryAt(xi_org);
position = dOmega.mapping();

xi = dOmega.inverseMapping(position);

format('long');
disp(xi);
% [dx_dxi, J] = dOmega.jacobian();

plot(position(1),position(2),'ko' )


%% Test boundary query
switch domain_patch.dim_
    case 2
        % 2D test
        n = 4;
        temp = linspace(0, 1, n);
        
        position = zeros(n, domain_patch.dim_);
        
        for bdr_patch = values(boundary_patch_map)
            dGamma = Differential(nurbs_basis, bdr_patch{1});

            for i = 1:n
                dGamma.queryAt(temp(i));
                
                position(i,:) = dGamma.mapping();
                normal = dGamma.normalVector();
                
                plot(position(i,1), position(i,2), 'ro');
                quiver(position(i,1), position(i,2), normal(1), normal(2), 'LineWidth', 2);
            end
        end
    case 3
        % 3D test
        n = 4;
        temp = linspace(0, 1, n);
        [xx, yy] = meshgrid(temp, temp);
        xx = xx(:);
        yy = yy(:);
        
        position = zeros(n, domain_patch.dim_);
        
        for bdr_patch = values(boundary_patch_map)
            dGamma = Differential(nurbs_basis, bdr_patch{1});
            
            for i = 1:n^2
                s = [xx(i) yy(i)];
                dGamma.queryAt(s);
                
                position(i,:) = dGamma.mapping();
                normal = dGamma.normalVector();
                               
                plot3(position(i,1), position(i,2), position(i,3), 'ro');
                quiver3(position(i,1), position(i,2), position(i,3), normal(1), normal(2), normal(3), 1.5, 'LineWidth', 2);
            end
        end
end





end
