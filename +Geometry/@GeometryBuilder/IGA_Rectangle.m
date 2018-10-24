function geometry = IGA_Rectangle(varargin)
%   varargin{1} = [L, D]
    import Geometry.*
    import Utility.BasicUtility.*
    import Utility.NurbsUtility.*
    
    % Generate geometry unit
    geometry = Geometry();
    
    % Generate isoparamtric topology in geometry{1}
    topo = Topology.NurbsTopology(2);
    geometry.num_topology_ = 1;
    geometry.topology_data_ = {topo};
    
    % Generate knot vectors, order, and control points
    knot_vectors = {[0, 0, 0, 0, 1, 1, 1, 1], [0, 0, 0, 0, 1, 1, 1, 1]};
    order = [3, 3];
    L = varargin{1}{1};
    D = varargin{1}{2};
    t_1 = linspace(0, L, 4);
    t_2 = linspace(-D/2, D/2, 4);
    
    [t_2, t_1] = meshgrid(t_2, t_1);
    
    topo.point_data_ = PointList([t_1(:), t_2(:), zeros(size(t_1(:))), ones(size(t_1(:)))]);
   
    % Get Domain patch
    domain_patch = topo.getDomainPatch();
    
    %> Generate domain nurbs
    domain_patch.nurbs_data_ = Nurbs(knot_vectors, order, topo.point_data_);
    
    % Create Boundary nurbs patch (Down_Side)
    patch = topo.newBoundayPatch('Down_Side');
    %> Generate nurbs
    id = [1 2 3 4];
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[0 1] [0]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(1), order(1), point, parametric_mapping);
    
    % Create Boundary nurbs patch (Up_Side)
    patch = topo.newBoundayPatch('Up_Side');
    %> Generate nurbs
    id = [13 14 15 16];
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[0 1] [1]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(1), order(1), point, parametric_mapping);
    
    % Create Boundary nurbs patch (Right_Side)
    patch = topo.newBoundayPatch('Right_Side');
    %> Generate nurbs
    id = [4 8 12 16];
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[1] [0 1]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(2), order(2), point, parametric_mapping);
       
    % Create Boundary nurbs patch (Left_Side)
    patch = topo.newBoundayPatch('Left_Side');
    %> Generate nurbs
    id = [1 5 9 13];
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[0] [0 1]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(2), order(2), point, parametric_mapping);
end

