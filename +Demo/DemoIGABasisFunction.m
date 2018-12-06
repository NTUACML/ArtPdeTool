function DemoIGABasisFunction
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
    pnt = [linspace(pnt(1,1), pnt(end,1), 21)' linspace(pnt(1,2), pnt(end,2), 21)'];
    
    position = domain_patch.nurbs_data_.evaluateNurbs(pnt);
    plot3(position(:,1), position(:,2), position(:,3), 'LineWidth', 1.5);
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




% create sample points in parametric space
t = linspace(0, 1, 20);
[xi, eta] = meshgrid(t, t);
xi = xi(:);
eta = eta(:);

for i = 1:length(xi)
    sample_pnt = {xi(i) eta(i)};
    query_unit.query_protocol_ = {Region.Domain, sample_pnt};
    nurbs_basis.query(query_unit);
    
    non_zero_id = query_unit.non_zero_id_;
    R = query_unit.evaluate_basis_{1};
    dR_dxi = query_unit.evaluate_basis_{2}(1,:);
    dR_deta = query_unit.evaluate_basis_{2}(2,:);
end

% control_point = nurbs_topology.domain_patch_data_.nurbs_data_.control_points_(:,1:3);
% val = R*control_point(non_zero_id,:);
% dval_dxi = dR_dxi*control_point(non_zero_id,:);
% dval_deta = dR_deta*control_point(non_zero_id,:);


end

function PlotBasisFunction(basis_id, nurbs_basis)
import BasisFunction.IGA.QueryUnit
import Utility.BasicUtility.Region

% plot the 'basis_id'th nurbs basis function...

end

