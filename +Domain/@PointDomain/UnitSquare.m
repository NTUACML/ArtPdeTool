function UnitSquare( this )
%UNITSQUARE Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.Point
    import Utility.PointUtility.Patch
    
    % create interior domain
    % let domain be the reference of this.interior_
    domain = this.interior_; 
    domain.dim_ = 2;
    % > node data define
    num = 4; num_node = num^2;
    domain.node_data_ = cell(num_node, 1);
    t = linspace(0, 1, num);
    [xx, yy] = meshgrid(t, t);
    
    for i = 1:num_node
        domain.node_data_{i} = Point(2, [xx(i), yy(i)]);
    end

    % create boundary domain
    % let domain be the reference of this.boundary_
    domain = this.boundary_;
    domain.dim_ = 2;
    % > node data define (same as interior node)
    domain.node_data_ = this.interior_.node_data_;

    % > patch data define
    num_patch = 4;
    domain.patch_data_ = cell(num_patch,1);
     
    %% Jeting 0730Consider using different interface for node_data_......It's very inconvience for matlab......
    id = 1:5;
%     id = find(abs(domain.node_data_(:,2) - 1) < eps);
    domain.patch_data_{1} = Patch('North_Face', 'Point', id);
    
%     id = find(abs(domain.node_data_(:,2)) < eps);
    domain.patch_data_{2} = Patch('South_Face', 'Point', id);

%     id = find(abs(domain.node_data_(:,1) - 1) < eps);
    domain.patch_data_{3} = Patch('East_Face', 'Point', id);

%     id = find(abs(domain.node_data_(:,1)) < eps);
    domain.patch_data_{3} = Patch('West_Face', 'Point', id);
 
    disp('Domain <Scatter Point> : ');
    disp('>> generated mesh data : UnitSquare!')
    
end

