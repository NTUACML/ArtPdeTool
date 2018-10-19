function DemoIGADomain
clc; clear; close all;

%%  create nurbs geometry
import Geometry.*
% geo = GeometryBuilder.create('IGA', 'Rectangle', [20, 2]);
% nurbs_topology = geo.topology_data_{1};

% object from nurbs tool box
nurbs_cylinder = nrbcylind(3,1,[],deg2rad(0),deg2rad(360));
nurbs_cylinder = nrbdegelev(nurbs_cylinder, [0 1]); 

% figure; hold on
% nrbplot(nurbs_cylinder,[20,5]); 
% hold off;
 
geo = GeometryBuilder.create('IGA', 'Nurbs_Object', nurbs_cylinder);
nurbs_topology = geo.topology_data_{1};

figure; hold on;
nurbs_topology.domain_patch_data_.nurbs_data_.plotNurbs([20 5]);
hold off;

%% Domain create
import Domain.*
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);
import BasisFunction.IGA.QueryUnit
import Utility.BasicUtility.Region

%% Test query function 
query_unit = QueryUnit();
xi = {0.1973 0.78229};
query_unit.query_protocol_ = {Region.Domain, xi};
results = nurbs_basis.query(query_unit);

non_zero_id = results{1};
R = results{2};
dR_dxi = results{3}(1,:);
dR_deta = results{3}(2,:);

nurbs_data = nurbs_topology.domain_patch_data_.nurbs_data_;
control_point = nurbs_data.control_points_(:,:);

nurbs_val = R*control_point(non_zero_id,1:3);
dnurbs_val_dxi = dR_dxi*control_point(non_zero_id,1:3);
dnurbs_val_deta = dR_deta*control_point(non_zero_id,1:3);


%% Test 
% dnurbs_cylinder = nrbderiv(nurbs_cylinder);
% [pnt,jac] = nrbdeval(nurbs_cylinder, dnurbs_cylinder, xi) ;


end

