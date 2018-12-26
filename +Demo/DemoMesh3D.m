function DemoMesh3D
clc; clear; close all;
import Utility.Resources.mesh3d

ex = 2;
ey = 4;
ez = 3;
mesh = mesh3d(ex, ey, ez, 1, 1, 1);

mesh.node
mesh.connect

import Utility.Resources.hexaplot

figure; hold on; grid on; view([150 20]); axis equal;
plot3(mesh.node(:,1), mesh.node(:,2), mesh.node(:,3), 'r.', 'MarkerSize', 12);
text(mesh.node(:,1), mesh.node(:,2), mesh.node(:,3), num2str([1:size(mesh.node,1)]'), 'FontSize',14);
xlabel('x'); ylabel('y'); zlabel('z');
hexaplot(mesh.connect, mesh.node(:,1), mesh.node(:,2), mesh.node(:,3));
hold off;

end

