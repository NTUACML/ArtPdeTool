function DemoIGA_InverseMapping
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
nurbs_tool.plotNurbs([21 21 21]); %view([50 30]);
nurbs_tool.plotControlMesh();
hold off;

%% Create Mapping
import Mapping.IGA.Mapping
mapping = Mapping(nurbs_basis);
patch_data = boundary_patch_map('eta_1');

import BasisFunction.IGA.QueryUnit
query_unit = QueryUnit();

temp = linspace(0, 1, 17);

for xi = temp
    query_unit.query_protocol_ = {patch_data, xi, 1};
    
    % Evaluate physical position at xi
    F = mapping.queryLocalMapping(query_unit);
    physical_position = F.calPhysicalPosition();
    
    % Given physical coordinate, find xi
    parametric_coordinate = mapping.inverseMapping(physical_position, patch_data);
    
    disp(xi);
    disp(parametric_coordinate);
    disp('-----------------')
end


end
