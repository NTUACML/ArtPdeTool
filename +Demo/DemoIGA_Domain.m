function DemoIGA_Domain
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

boundary_oatch = nurbs_topology.boundary_patch_data_;
%% Create Domain
iga_domain = DomainBuilder.create('IGA');

%% Create Basis
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Create Nurbs tools
nurbs_tool = NurbsTools(nurbs_basis);

% Plot nurbs
figure; hold on; grid on; %axis equal;
nurbs_tool.plotNurbs([21 21 21]); view([50 30]);
nurbs_tool.plotControlMesh();
hold off;

%% Test query basis function 
import BasisFunction.IGA.QueryUnit
query_unit = QueryUnit();

for i = 1:5
    % Query basis function point by point using domain basis functions
    xi = rand(1,domain_patch.dim_);
    query_unit.query_protocol_ = {Region.Domain, xi, 1};
    nurbs_basis.query(query_unit);
    
    non_zero_id = query_unit.non_zero_id_;
    R = query_unit.evaluate_basis_{1};
    dR_dxi = query_unit.evaluate_basis_{2}(1,:);
    dR_deta = query_unit.evaluate_basis_{2}(2,:);
    
    control_point = domain_patch.nurbs_data_.control_points_(:,1:3);
    
    % Evaluate nurbs & derivatives using basis function
    val = R*control_point(non_zero_id,:);
    dval_dxi = dR_dxi*control_point(non_zero_id,:);
    dval_deta = dR_deta*control_point(non_zero_id,:);
    
    % Evaluate nurbs & derivatives using nurbs tool directly
    [position, gradient] = nurbs_tool.evaluateNurbs(xi, 'gradient');
    
    % Compare results
    str = '(%10.5f%10.5f%10.5f) (%10.5f%10.5f%10.5f)\n';
    fprintf(str, val, position);
    fprintf(str, dval_dxi, gradient{1});
    fprintf(str, dval_deta, gradient{2});
    disp('-----------------------------------------------------------------');
end

patch_name = 'eta_0';

for i = 1:5
    % Query basis function point by point using boundary basis functions
    xi = rand(1,boundary_oatch(patch_name).dim_);
    query_unit.query_protocol_ = {Region.Boundary, xi, 1};
    nurbs_basis.query(query_unit, patch_name);
    
    non_zero_id_bdr = query_unit.non_zero_id_;
    R_bdr = query_unit.evaluate_basis_{1};
    dR_dxi_bdr = query_unit.evaluate_basis_{2}(1,:);
    dR_deta_bdr = query_unit.evaluate_basis_{2}(2,:);

    % Query basis function point by point using domain basis functions
    query_unit.query_protocol_ = {Region.Domain, [xi 0], 1};
    nurbs_basis.query(query_unit);
    
    non_zero_id_dom = query_unit.non_zero_id_;
    R_dom = query_unit.evaluate_basis_{1};
    dR_dxi_dom = query_unit.evaluate_basis_{2}(1,:);
    dR_deta_dom = query_unit.evaluate_basis_{2}(2,:);   
end


%% Create expression
exp1 = Expression.ExpressionBase;

%% Test domain integral
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

%% Plot domain integration points in parametric space
figure; hold on; grid on; axis equal;
nurbs_tool.plotParametricMesh();

for i = 1:domain_integration_rule.num_integral_unit_
    position = domain_integration_rule.integral_unit_{i}.quadrature_{2};
    switch size(position,2)
        case 2
            plot(position(:,1), position(:,2), 'r.');
        case 3
            plot3(position(:,1), position(:,2), position(:,3), 'k.', 'MarkerSize', 10);
    end
end
hold off;

%% Plot domain integration points in physical space
figure; hold on; grid on; %axis equal;
nurbs_tool.plotNurbs();

for i = 1:domain_integration_rule.num_integral_unit_
    position = domain_integration_rule.integral_unit_{i}.quadrature_{2};
    position = nurbs_tool.evaluateNurbs(position, 'position');

    plot3(position(:,1), position(:,2), position(:,3), 'k.', 'MarkerSize', 10);
end
hold off;

%% Test boundary integral
% TODO: The evaluation functin is moved to nurbs_tool now.
% Hence we can not use nurbs_data to evaluate directly.
% More over, there is no boundary basis functions for
% boundary nurbs. In order to modify the problem, the
% boundary basis functinos need to be constructed when the
% basis functions object is created. The nurbs_tool will
% have the function that can compute the boundary nurbs

% for patch_key = keys(nurbs_topology.boundary_patch_data_)
%     bdr_patch = nurbs_topology.getBoundayPatch(patch_key{1});
%     iga_domain.calIntegral(bdr_patch, exp1);
% end
% 
% for rule_key = 2:5
%     bdr_integration_rule = iga_domain.integration_rule_(rule_key);
%     
%     for i = 1:bdr_integration_rule.num_integral_unit_
%         position = bdr_integration_rule.integral_unit_{i}.quadrature_{2};
%         position = domain_patch.nurbs_data_.evaluateNurbs(position);
%         
%         plot3(position(:,1), position(:,2), position(:,3), 'o');
%     end
% end

end
