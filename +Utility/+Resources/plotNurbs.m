function plotNurbs(nurbs, varargin)
import Utility.Resources.mesh2d
N = varargin{1}{1};
mesh = mesh2d(N(1), N(2), 1, 1);

p = zeros(mesh.nn, 3);

import Utility.Resources.NurbsMapping
for i = 1:length(mesh.xI(:,1))
    p(i,:) = [NurbsMapping(mesh.xI(i,:), nurbs)]';
end

fv.vertices = p;
fv.faces = mesh.connect;
fv.facevertexcdata = ones(mesh.nn,1);
patch(fv,'CDataMapping','scaled','EdgeColor','none','FaceColor','interp','FaceAlpha',0.8);

% plot knot mesh
if strcmp(varargin{1}{2}, 'plotKnotMesh')
    knot_1 = unique(nurbs.knots{1});
    knot_2 = unique(nurbs.knots{2});
    
    xi = linspace(0,1,N(1)+1)';
    eta = linspace(0,1,N(2)+1)';
    
    for i_knot = 1:length(knot_1(1,:))
        pp = [knot_1(i_knot)*ones(size(eta)) eta];
        p = zeros(size(pp,1), 3);
        for i = 1:length(pp(:,1))
            p(i,:) = [NurbsMapping(pp(i,:), nurbs)]';
        end
        plot3(p(:,1), p(:,2), p(:,3), 'k-', 'Linewidth', 1.2);
    end

    for i_knot = 1:length(knot_2(1,:))
        pp = [xi knot_2(i_knot)*ones(size(xi))];
        p = zeros(size(pp,1), 3);
        for i = 1:length(pp(:,1))
            p(i,:) = [NurbsMapping(pp(i,:), nurbs)]';
        end
        plot3(p(:,1), p(:,2), p(:,3), 'k-', 'Linewidth', 1.2);
    end    
end

end


