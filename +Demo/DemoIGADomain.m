function DemoIGADomain
clc; clear; close all;

%% create Geometry
import Geometry.*

% create by PDEtool database
% length = 20;
% hight = 2;
% geo = GeometryBuilder.create('IGA', 'Rectangle', {length, hight});
% nurbs_topology = geo.topology_data_{1};

height = 3;
radius = 1;
center = [];
sang = deg2rad(0);      % start angle
eang = deg2rad(360);    % end angle

geo = GeometryBuilder.create('IGA', 'CylinderSurface', {height, radius, center, sang, eang});
nurbs_topology = geo.topology_data_{1};
nurbs_data = nurbs_topology.domain_patch_data_.nurbs_data_;
nurbs_data.degreeElevation([0 1]);
nurbs_data.knotInsertion({[0.1], [0.125 0.375 0.625 0.875]});

% % create by object from the nurbs tool box
% nurbs_cylinder = nrbcylind(3,1,[],deg2rad(0),deg2rad(360));
% nurbs_cylinder = nrbdegelev(nurbs_cylinder, [0 1]); 
% nurbs_cylinder = nrbkntins(nurbs_cylinder,{[0.1], [0.125 0.375 0.625 0.875]}); 
% geo = GeometryBuilder.create('IGA', 'Nurbs_Object', nurbs_cylinder);
% nurbs_topology = geo.topology_data_{1};

%% plot nurbs surface
figure; hold on;
nurbs_topology.domain_patch_data_.nurbs_data_.plotNurbs([36 2]);
hold off;

%% create Domain
import Domain.*
iga_domain = DomainBuilder.create('IGA');

%% create Basis
nurbs_basis = iga_domain.generateBasis(nurbs_topology);
import BasisFunction.IGA.QueryUnit
import Utility.BasicUtility.Region

%% Test query function 
% query_unit = QueryUnit();
% xi = {0.1973 0.78229};
% query_unit.query_protocol_ = {Region.Domain, xi};
% results = nurbs_basis.query(query_unit);
% 
% non_zero_id = results{1};
% R = results{2};
% dR_dxi = results{3}(1,:);
% dR_deta = results{3}(2,:);
% 
% control_point = nurbs_topology.domain_patch_data_.nurbs_data_.control_points_(:,1:3);
% 
% val = R*control_point(non_zero_id,:);
% dval_dxi = dR_dxi*control_point(non_zero_id,:);
% dval_deta = dR_deta*control_point(non_zero_id,:);
% 
% dnurbs_cylinder = nrbderiv(nurbs_cylinder);
% [pnt,jac] = nrbdeval(nurbs_cylinder, dnurbs_cylinder, xi) ;

%% create expression
exp1 = Expression.ExpressionBase;

%% Integral variation equations
% domain integral
int_doamin_patch = nurbs_topology.getDomainPatch();
% integrating the expression over the domain patch, 'int_doamin_patch', by
% dividing domain patch into sub-domains. 
% The dividing process is performed according to the user defined stratergies. 
% Here we use the interceptions of knot vectors to form the
% sub-domains, which is denoted by 'Default'.
% The second parameter decides how many quad points are generated in each
% parametric coordinate.
% number_quad_pt = [2 2];
% iga_domain.calIntegral(int_doamin_patch, exp1, {'Default', number_quad_pt});
iga_domain.calIntegral(int_doamin_patch, exp1);

integration_rule = iga_domain.integration_rule_(1);

% integration_rule.integral_unit_{1}.quadrature_{1}
% integration_rule.integral_unit_{1}.quadrature_{2}
% integration_rule.integral_unit_{1}.quadrature_{3}

figure; hold on;
knot_vectors = nurbs_topology.domain_patch_data_.nurbs_data_.knot_vectors_;
unique_knot{1} = unique(knot_vectors{1});
unique_knot{2} = unique(knot_vectors{2});
[yy, xx] = meshgrid(unique_knot{2}, unique_knot{1});

m = mesh2d(length(unique_knot{1})-1, length(unique_knot{2})-1, 1, 1);
m.xI(:,1) = xx(:);
m.xI(:,2) = yy(:);

quadplot(m.connect, m.xI(:,1), m.xI(:,2));
for i = 1:integration_rule.num_integral_unit_
    position = integration_rule.integral_unit_{i}.quadrature_{2};
    plot(position(:,1), position(:,2), 'r.');
end

end
