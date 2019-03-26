function Demo_PlotMesh
clc; clear; close all;

ex = 2;
ey = 4;
ez = 3;

%%  Demonstrate how to construct & plot a 3d hexa mesh 
import Utility.Resources.mesh3d
mesh3 = mesh3d(ex, ey, ez, 1, 1, 1);

mesh3.node
mesh3.connect

import Utility.Resources.hexaplot

figure; hold on; grid on; view([150 20]); axis equal;
plot3(mesh3.node(:,1), mesh3.node(:,2), mesh3.node(:,3), 'r.', 'MarkerSize', 12);
text(mesh3.node(:,1), mesh3.node(:,2), mesh3.node(:,3), num2str([1:size(mesh3.node,1)]'), 'FontSize',14);
xlabel('x'); ylabel('y'); zlabel('z');
hexaplot(mesh3.connect, mesh3.node(:,1), mesh3.node(:,2), mesh3.node(:,3));
hold off;

%%  Demonstrate how to construct & plot a 2d quad mesh
import Utility.Resources.mesh2d
mesh2 = mesh2d(ex, ey, 1, 1);

mesh2.node
mesh2.connect

import Utility.Resources.quadplot

figure; hold on; grid on; axis equal;
plot(mesh2.node(:,1), mesh2.node(:,2), 'r.', 'MarkerSize', 12);
text(mesh2.node(:,1), mesh2.node(:,2), num2str([1:size(mesh2.node,1)]'), 'FontSize',14);
xlabel('x'); ylabel('y'); 
quadplot(mesh2.connect, mesh2.node(:,1), mesh2.node(:,2));
hold off;


end

