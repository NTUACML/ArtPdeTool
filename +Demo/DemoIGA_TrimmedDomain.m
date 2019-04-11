function DemoIGA_TrimmedDomain
clc; clear; close all;

%% create Geometry
import Geometry.* 
import Domain.*
import Utility.BasicUtility.*
import Utility.NurbsUtility.* 

xml_path = './ArtPDE_IGA_Plane_quarter_hole_trimmed.art_geometry';

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

% plor nurbs boundary patch & trimmed curve
import BasisFunction.IGA.QueryUnit
query_boundary = QueryUnit();

n = 21;
temp = linspace(0, 1, n);
position = zeros(n, 2);

for bdr_patch = values(boundary_patch_map)
    for i = 1:n
        s = temp(i);    
        query_boundary.query_protocol_ = {bdr_patch{1}, s, 0};
        nurbs_basis.query(query_boundary);
        position(i,:) = query_boundary.evaluate_basis_{1} * domain_patch.nurbs_data_.control_points_(query_boundary.non_zero_id_,1:2);        
    end
    plot(position(:,1), position(:,2), '-r', 'LineWidth', 2);
end

%% Create expression
eexpression = Expression.ExpressionBase;

%% Test domain integral
iga_domain.calIntegral(domain_patch, eexpression);
domain_integration_rule = iga_domain.integration_rule_(1);

%% Plot domain integration points in physical space
for i = 1:domain_integration_rule.num_integral_unit_
    position = domain_integration_rule.integral_unit_{i}.quadrature_{2};
    position = nurbs_tool.evaluateNurbs(position, 'position');

    plot3(position(:,1), position(:,2), position(:,3), 'k.', 'MarkerSize', 10);
end

%% Test boundary integral
for patch_key = keys(nurbs_topology.boundary_patch_data_)
    bdr_patch = nurbs_topology.getBoundayPatch(patch_key{1});   
    
    iga_domain.calIntegral(bdr_patch, eexpression, {'Default', 3});
end

for rule_key = 2:6
    bdr_integration_rule = iga_domain.integration_rule_(rule_key);
       
    for i = 1:bdr_integration_rule.num_integral_unit_
        xi = bdr_integration_rule.integral_unit_{i}.quadrature_{2}; 
        for j = 1:size(xi,1)
            query_boundary.query_protocol_ = {bdr_integration_rule.integral_patch_, xi(j,:), 0};
            nurbs_basis.query(query_boundary);
                       
            position = query_boundary.evaluate_basis_{1}*domain_patch.nurbs_data_.control_points_(query_boundary.non_zero_id_,1:3);
            plot3(position(:,1), position(:,2), position(:,3), 'k.', 'MarkerSize', 12);            
        end    
    end  
end

end
