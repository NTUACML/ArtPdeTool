function DemoIGADomain
clc; clear; close all;

%addpath ../../NonlinearWeakForm

%%  create nurbs geometry
import Geometry.*
geo = GeometryBuilder.create('IGA', 'Rectangle', [20, 2]);
nurbs_topology = geo.topology_data_{1};

% figure; hold on;
% nurbs_topology.domain_patch_data_.nurbs_data_.plotNurbs([20 5]);
% hold off;

%% Domain create
import Domain.*
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);




end

