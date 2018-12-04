function DemoIGADomain
clc; clear; close all;

%% create Geometry
import Geometry.* 

xml_path = './ArtPDE_IGA.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

domain_patch = nurbs_topology.getDomainPatch();

% plot nurbs surface & bounday nurbs
figure; hold all; view([0 90]); grid on; axis equal;
domain_patch.nurbs_data_.plotNurbsSurface({[20 20] 'plotKnotMesh'});

for patch_key = keys(nurbs_topology.boundary_patch_data_)
    patch = nurbs_topology.getBoundayPatch(patch_key{1});
    pnt = patch.nurbs_data_.control_points_(:,1:2);
    
    position = domain_patch.nurbs_data_.evaluateNurbs(pnt);
    plot(position(:,1), position(:,2), 'r-');
end
hold off;

%% create Domain
import Domain.*
iga_domain = DomainBuilder.create('IGA');

%% create Basis
nurbs_basis = iga_domain.generateBasis(nurbs_topology);
import BasisFunction.IGA.QueryUnit
import Utility.BasicUtility.Region

%% Test query function 
query_unit = QueryUnit();
xi = {0.1973 0.78229};
query_unit.query_protocol_ = {Region.Domain, xi};
nurbs_basis.query(query_unit);

non_zero_id = query_unit.non_zero_id_;
R = query_unit.evaluate_basis_{1};
dR_dxi = query_unit.evaluate_basis_{2}(1,:);
dR_deta = query_unit.evaluate_basis_{2}(2,:);

control_point = nurbs_topology.domain_patch_data_.nurbs_data_.control_points_(:,1:3);

val = R*control_point(non_zero_id,:);
dval_dxi = dR_dxi*control_point(non_zero_id,:);
dval_deta = dR_deta*control_point(non_zero_id,:);

%% create expression
exp1 = Expression.ExpressionBase;

%% domain integral
% integrating the expression over the domain patch, 'int_doamin_patch', by
% dividing domain patch into sub-domains. 
% The dividing process is performed according to the user defined stratergies. 
% Here we use the interceptions of knot vectors to form the
% sub-domains, which is denoted by 'Default'.
% The second parameter decides how many quad points are generated in each
% parametric coordinate.

% number_quad_pt = [2 2];
% iga_domain.calIntegral(domain_patch, exp1, {'Default', number_quad_pt});
iga_domain.calIntegral(domain_patch, exp1);

domain_integration_rule = iga_domain.integration_rule_(1);

%% plot integration point in parametric space
figure; hold on;
domain_patch.nurbs_data_.plotParametricMesh();
for i = 1:domain_integration_rule.num_integral_unit_
    position = domain_integration_rule.integral_unit_{i}.quadrature_{2};
    plot(position(:,1), position(:,2), 'r.');
end
hold off;

%% plot integration point in physical space
figure; hold on; view([0 90]); grid on; axis equal;
domain_patch.nurbs_data_.plotNurbsSurface({[20 20] 'plotKnotMesh'});

for i = 1:domain_integration_rule.num_integral_unit_
    position = domain_integration_rule.integral_unit_{i}.quadrature_{2};
    position = domain_patch.nurbs_data_.evaluateNurbs(position);

    plot3(position(:,1), position(:,2), position(:,3), 'r.');
end

%% boundary integral

for patch_key = keys(nurbs_topology.boundary_patch_data_)
    bdr_patch = nurbs_topology.getBoundayPatch(patch_key{1});
    iga_domain.calIntegral(bdr_patch, exp1);
end

for rule_key = 2:5
    bdr_integration_rule = iga_domain.integration_rule_(rule_key);
    
    for i = 1:bdr_integration_rule.num_integral_unit_
        position = bdr_integration_rule.integral_unit_{i}.quadrature_{2};
        position = domain_patch.nurbs_data_.evaluateNurbs(position);
        
        plot3(position(:,1), position(:,2), position(:,3), 'o');
    end
%     
%     temp = 0;
%     for i = 1:bdr_integration_rule.num_integral_unit_
%         temp = temp + sum(bdr_integration_rule.integral_unit_{i}.quadrature_{3});
%     end
    
end
hold off;

end
