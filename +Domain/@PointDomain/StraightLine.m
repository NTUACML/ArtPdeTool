function StraightLine( this )
%STRAIGHTLINE Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.Point
    import Utility.PointUtility.Patch
    
    % create interior domain
    % let domain be the reference of this.interior_
    domain = this.interior_; 
    domain.dim_ = 1;
    % > node data define
    num_node = 11;
    domain.node_data_ = cell(num_node, 1);
    for i = 1:num_node
        value = (i-1) * 1/(num_node-1);
        domain.node_data_{i} = Point(1, value);
    end

    % create boundary domain
    % let domain be the reference of this.boundary_
    domain = this.boundary_;
    domain.dim_ = 1;
    % > node data define (same as interior node)
    domain.node_data_ = this.interior_.node_data_;

    % > patch data define
    num_patch = 2;
    domain.patch_data_ = cell(num_patch,1);
    
    domain.patch_data_{1} = Patch('Left', 'Point', [1]);
    domain.patch_data_{2} = Patch('Right', 'Point', [num_node]);
    
    
    disp('Domain <Scatter Point> : ');
    disp('>> generated point domain data : StraightLine!')   
end

