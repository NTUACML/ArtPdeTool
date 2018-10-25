function geometry = IGA_Tool_Box( varargin )
%   varargin{1} = object from nurbs tool box
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
    knot_vectors = varargin{1}.knots;
    order = varargin{1}.order-1;
    
    temp_point = zeros(prod(varargin{1}.number), 4);
    switch length(varargin{1}.number)
        case 1
            for i = 1:varargin{1}.number(1)
                temp_point(i,:) = varargin{1}.coefs(:,i)';
            end
        case 2
            for j = 1:varargin{1}.number(2)
                for i = 1:varargin{1}.number(1)
                    temp_point((j-1)*varargin{1}.number(1)+i,:) = varargin{1}.coefs(:,i,j)';
                end
            end
        case 3
            disp('currebtly not support for solid nurbs');
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
    if ~iscell(knot_vectors)
        knot_vectors = {knot_vectors};
    end
    domain_patch.nurbs_data_ = Nurbs(knot_vectors, order, topo.point_data_);
    
    
end

