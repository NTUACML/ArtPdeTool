clc; clear; close all;

%% create control points by PointList
import Utility.BasicUtility.*
L = 20;
D = 2;
t_1 = linspace(0, L, 4);
t_2 = linspace(-D/2, D/2, 4);

[t_1, t_2] = meshgrid(t_1, t_2);

control_point = PointList([t_1(:), t_2(:), zeros(size(t_1(:))), ones(size(t_1(:)))]);
%% create Nurbs object
import Utility.NurbsUtility.*
knot_vectors = {[0, 0, 0, 0, 1, 1, 1, 1], [0, 0, 0, 0, 1, 1, 1, 1]};
order = [3, 3];
domain_nurbs = Nurbs(knot_vectors, order, control_point);

domain_nurbs.type_
domain_nurbs.dispControlPoints();
domain_nurbs.plotNurbs([20, 10]);
%%  create nurbs patch

