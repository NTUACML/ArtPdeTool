function DemoIGALaplace
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Problem parameters
isPlotNurbsDomain = 1;
isPlotDomainIntegrationRule = 1;
%% Geometry data input
% create by object from the nurbs tool box
srf = nrb4surf([0.0 0.0 0.0],[1.0 0.0 0.0],[0.0 1.0 0.0],[1.0 1.0 0.0]);
srf = nrbdegelev(srf, [1 1]); 

% t = linspace(0.25, 0.75, 3);
t = linspace(0.1, 0.9, 9);
srf = nrbkntins(srf,{t, t}); 

geo = GeometryBuilder.create('IGA', 'Nurbs_Object', srf);
nurbs_topology = geo.topology_data_{1};

domain_nurbs = nurbs_topology.domain_patch_data_.nurbs_data_;

% plot nurbs surface
if isPlotNurbsDomain
    figure; hold on; view([0 90]); grid on; 
    domain_nurbs.plotNurbsSurface({[2 2] 'plotKnotMesh'});
    hold off;
end

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Variable define   
var_t = iga_domain.generateVariable('temperature', nurbs_basis,...
                                    VariableType.Scalar, 1);      
%% Test variable define
test_t = iga_domain.generateTestVariable(var_t, nurbs_basis);

%% Set domain mapping - > physical domain to parametric domain
iga_domain.setMapping(nurbs_basis);

% test mapping
% import BasisFunction.IGA.QueryUnit
% import Utility.BasicUtility.Region
% query_unit = QueryUnit();
% xi = {0.1973 0.78229};
% query_unit.query_protocol_ = {Region.Domain, xi};
% mapping_unit = iga_domain.mapping_.queryLocalMapping(query_unit);
% [dx_dxi, J] = mapping_unit.calJacobian();

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_t, var_t});

%% Integral variation equations
% Domain integral
int_doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(int_doamin_patch, exp1);

% plot integration point
if isPlotDomainIntegrationRule
    integration_rule = iga_domain.integration_rule_(1);
    % plot integration point in parametric space
    figure; hold on; axis equal;
    domain_nurbs.plotParametricMesh();
    for i = 1:integration_rule.num_integral_unit_
        position = integration_rule.integral_unit_{i}.quadrature_{2};
        plot(position(:,1), position(:,2), 'r.');
    end
    hold off;
    
    % plot integration point in physical space
    figure; hold on; view([130 30]); grid on;
    domain_nurbs.plotNurbsSurface({[24 1] 'plotKnotMesh'});
    
    for i = 1:integration_rule.num_integral_unit_
        position = integration_rule.integral_unit_{i}.quadrature_{2};
        position = domain_nurbs.evaluateNurbs(position);
        
        plot3(position(:,1), position(:,2), position(:,3), 'r.');
    end
end

%% Constraint (Acquire prescribed D.O.F.)
% up_side_patch = iso_topo.getBoundayPatch('Up_Side');
% down_side_patch = iso_topo.getBoundayPatch('Down_Side');
% t_constraint_up = iga_domain.generateConstraint(up_side_patch, var_t, {1, @()1});
% t_constraint_down = iga_domain.generateConstraint(down_side_patch, var_t, {1, @()0});
%% Solve domain equation system
iga_domain.solve('default');

%% Show result
disp(var_t);




end