function DemoIGA_BasisFunction
clc; clear; close all;

%% create Geometry
import Geometry.* 
% ArtPDE_IGA_3D_Lens_left; ArtPDE_IGA_Plane_quarter_hole

xml_path = './ArtPDE_IGA_3D_Lens_left.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

domain_patch = nurbs_topology.getDomainPatch();

%% create Domain
import Domain.*
iga_domain = DomainBuilder.create('IGA');

%% create Basis
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% plot nurbs surface & bounday nurbs
% import Utility.NurbsUtility.NurbsTools
% nurbs_tool = NurbsTools(nurbs_basis);
% 
% figure; hold on; grid on; axis equal;
% nurbs_tool.plotNurbs(21*ones(1,domain_patch.dim_));
% nurbs_tool.plotControlMesh();
% hold off;

%% Test query function
import BasisFunction.IGA.QueryUnit
import Utility.BasicUtility.Region

query_unit = QueryUnit();
query_unit.query_protocol_{1} = Region.Domain;
query_unit.query_protocol_{3} = 1; % Evaluate value & 1st order derivatives

% create sample points in parametric space
xi = rand(20, domain_patch.dim_);

for i = 1:length(xi)
    query_unit.query_protocol_{2} = xi(i,:);
    nurbs_basis.query(query_unit);
    
    non_zero_id = query_unit.non_zero_id_;
    R = query_unit.evaluate_basis_{1};
    dR_dxi = query_unit.evaluate_basis_{2}(1,:);
    dR_deta = query_unit.evaluate_basis_{2}(2,:);
    dR_dzeta = query_unit.evaluate_basis_{2}(3,:);
    
    p = num2cell(domain_patch.nurbs_data_.order_);
    knots = domain_patch.nurbs_data_.knot_vectors_;
    omega = domain_patch.nurbs_data_.control_points_(:,4);
    
    [ GlobalDof_, R_, dR_dxi_ ] = Nurbs_ShapeFunc( num2cell(xi(i,:)), p, knots, omega );
    
    disp(['--------------- ', num2str(xi(i,:))]);
    disp(norm(non_zero_id-GlobalDof_));
    disp(norm(R-R_));
    disp(norm(dR_dxi-dR_dxi_(1,:)));
    disp(norm(dR_deta-dR_dxi_(2,:)));
    disp(norm(dR_dzeta-dR_dxi_(3,:)));
end

end

function PlotBasisFunction(basis_id, nurbs_basis)
import BasisFunction.IGA.QueryUnit
import Utility.BasicUtility.Region

% plot the 'basis_id'th nurbs basis function...

end

function [ GlobalDof, R, dR_dxi ] = Nurbs_ShapeFunc( xi, p, knots, omega )
%NURBS_SHAPEFUNC Summary of this function goes here
%   Detailed explanation goes here
import BasisFunction.IGA.NurbsBasisFunction
import Utility.BasicUtility.TensorProduct


[span_id{1},ders{1}] = NurbsBasisFunction.DersBasisFuns(xi{1}, p{1} , knots{1});
[span_id{2},ders{2}] = NurbsBasisFunction.DersBasisFuns(xi{2}, p{2} , knots{2});
[span_id{3},ders{3}] = NurbsBasisFunction.DersBasisFuns(xi{3}, p{3} , knots{3});

spanVec{1} = ((span_id{1} - p{1}) + 1 : span_id{1} + 1)';
spanVec{2} = ((span_id{2} - p{2}) + 1 : span_id{2} + 1)';
spanVec{3} = ((span_id{3} - p{3}) + 1 : span_id{3} + 1)';

N_i = (length(knots{1})-1) - p{1};
N_j = (length(knots{2})-1) - p{2};
N_k = (length(knots{3})-1) - p{3};
TD_3 = TensorProduct({N_i N_j N_k});

n = p{1} + 1;
m = p{2} + 1;
q = p{3} + 1;
LocalDof = n * m;
Dof = n * m * q;

LocalR = zeros(1, LocalDof);
R = zeros(1, Dof);
dR_dxi = zeros(2, Dof);
LocalDof = zeros(LocalDof,1);
GlobalDof = zeros(Dof, 1);

sum_tol = 0;
sum_xi = 0;
sum_eta = 0;
sum_zeta=0;

for k = 1 : q
    for j = 1 : m
        global_index = TD_3.to_global_index({spanVec{1} spanVec{2}(j) spanVec{3}(k)});
        uDof=global_index;
        LocalDof((j * n) - n + 1 : (j * n)) = global_index;
        w_u = omega(uDof);
        
        % R
        temp = (ders{2}(j, 1) .* ders{1}(:, 1)) .* w_u; % Why take transpose before .* w_u?
        LocalR(1, n * (j - 1) + 1 :  n * (j - 1) + n) = temp';
        %sum_tol = sum_tol + sum(temp);
        
        %dR/dxi
        temp = (ders{2}(j, 1) .* ders{1}(:, 2)) .* w_u; % Why take transpose before .* w_u?
        LocaldR(1, n * (j - 1) + 1 :  n * (j - 1) + n) = temp';
        %sum_xi = sum_xi + sum(temp);
        
        %dR/deta
        temp = (ders{2}(j, 2) .* ders{1}(:, 1)) .* w_u; % Why take transpose before .* w_u?
        LocaldR(2, n * (j - 1) + 1 :  n * (j - 1) + n) = temp';
        %sum_eta = sum_eta + sum(temp);
        
    end
    GlobalDof((m * n * (k - 1) + 1 : m * n * (k - 1) + m * n)) = LocalDof;
    % R
    temp = (ders{3}(k, 1) .* LocalR(1,:));
    R(1, m * n * (k - 1) + 1 : m * n * (k - 1) + m * n) = temp;
    sum_tol = sum_tol + sum(temp);
    
    %dR/dxi (3)
    temp = (ders{3}(k, 1) .* LocaldR(1,:));
    dR_dxi(1, m * n * (k - 1) + 1 : m * n * (k - 1) + m * n) = temp;
    sum_xi = sum_xi + sum(temp);
    
    %dR/deta (3)
    temp = (ders{3}(k, 1) .* LocaldR(2,:));
    dR_dxi(2, m * n * (k - 1) + 1 : m * n * (k - 1) + m * n) = temp;
    sum_eta = sum_eta + sum(temp);
    
    %dR/dzeta (3)
    temp = ( LocalR(1,:) .* ders{3}(k, 2));
    dR_dxi(3, m * n * (k - 1) + 1 : m * n * (k - 1) + m * n) = temp;
    sum_zeta = sum_zeta + sum(temp);
    
end

dR_dxi(1,:) = (dR_dxi(1,:) .* sum_tol - R .* sum_xi) ./ sum_tol.^2;
dR_dxi(2,:) = (dR_dxi(2,:) .* sum_tol - R .* sum_eta) ./ sum_tol.^2;
dR_dxi(3,:) = (dR_dxi(3,:) .* sum_tol - R .* sum_zeta) ./ sum_tol.^2;
R = R ./ sum_tol;

end




