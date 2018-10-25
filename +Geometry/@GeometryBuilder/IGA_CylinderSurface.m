function geometry = IGA_CylinderSurface( varargin )
%   varargin{1} = object from nurbs tool box
    import Geometry.*
    import Utility.BasicUtility.*
    import Utility.NurbsUtility.*
    
    % create nurbs tool box object
    tool_box_object = nrbcylind(varargin{1}{1}, varargin{1}{2}, varargin{1}{3}, varargin{1}{4}, varargin{1}{5});
    
    % Generate geometry unit
    geometry = Geometry();
    
    % Generate isoparamtric topology in geometry{1}
    topo = Topology.NurbsTopology(2);
    geometry.num_topology_ = 1;
    geometry.topology_data_ = {topo};
    
    % Generate knot vectors, order, and control points
    knot_vectors = tool_box_object.knots;
    order = tool_box_object.order-1;
    
    temp_point = zeros(tool_box_object.number(1)*tool_box_object.number(2), 4);
    for j = 1:tool_box_object.number(2)
        for i = 1:tool_box_object.number(1)
            temp_point((j-1)*tool_box_object.number(1)+i,:) = tool_box_object.coefs(:,i,j)';
        end
    end
    % the coordinates of control points from nurbs_tool_box containe
    % weighting, we have to normalize them to obtain the PHYSICAL
    % coordinates
    temp_point(:,1) = temp_point(:,1)./temp_point(:,4);
    temp_point(:,2) = temp_point(:,2)./temp_point(:,4);
    temp_point(:,3) = temp_point(:,3)./temp_point(:,4);

    topo.point_data_ = PointList(temp_point);
   
    % Get Domain patch
    domain_patch = topo.getDomainPatch();
    
    %> Generate domain nurbs
    domain_patch.nurbs_data_ = Nurbs(knot_vectors, order, topo.point_data_);
    
    basis_num = domain_patch.nurbs_data_.basis_number_;
    % Create Boundary nurbs patch (Down_Side)
    patch = topo.newBoundayPatch('Down_Side');
    %> Generate nurbs
    id = 1:basis_num(1);
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[0 1] [0]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(1), order(1), point, parametric_mapping);
    
    % Create Boundary nurbs patch (Up_Side)
    patch = topo.newBoundayPatch('Up_Side');
    %> Generate nurbs
    id = prod(basis_num)-basis_num(1)+1:prod(basis_num);
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[0 1] [1]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(1), order(1), point, parametric_mapping);
    
    % Create Boundary nurbs patch (Right_Side)
    patch = topo.newBoundayPatch('Right_Side');
    %> Generate nurbs
    id = linspace(basis_num(1), prod(basis_num), basis_num(2));
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[1] [0 1]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(2), order(2), point, parametric_mapping);
       
    % Create Boundary nurbs patch (Left_Side)
    patch = topo.newBoundayPatch('Left_Side');
    %> Generate nurbs
    id = linspace(1, prod(basis_num)-basis_num(1)+1, basis_num(2));
    point = PointList(topo.point_data_(id,:));
    parametric_mapping = {[0] [0 1]};
    patch.nurbs_data_ = BoundaryNurbs(knot_vectors(2), order(2), point, parametric_mapping);
    
    % Create Boundary nurbs patch (Up_Side_Partilly)
    patch = topo.newBoundayPatch('Up_Side_Partially');
    %> Generate nurbs
    crv = nrbcirc(varargin{1}{2},[0 0 varargin{1}{1}],varargin{1}{4}, 0.5*varargin{1}{5});
    for i = 1:crv.number
        crv.coefs(1:3,i) = crv.coefs(1:3,i)/crv.coefs(4,i);
    end
    
    point = PointList(crv.coefs');
    parametric_mapping = {[0 0.5] [1]};
    patch.nurbs_data_ = BoundaryNurbs({crv.knots}, crv.order-1, point, parametric_mapping);
    
end

