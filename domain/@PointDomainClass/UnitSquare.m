function UnitSquare( this )
%UNITSQUARE Summary of this function goes here
%   Detailed explanation goes here
    
    num = 4;
    this.num_node_ = num^2; 
    this.num_boundary_node_ = 2*num + 2*(num-2);
    this.dim_ = 2;
    t = linspace(0, 1, num );
    [xx, yy] = meshgrid(t, t);
    
    this.node_data_ = [xx(:), yy(:)];
    
    this.num_boundary_patch_ = 4;
    
    this.boundary_patch_ = cell(this.num_boundary_node_, 1);
    
    id = find(abs(this.node_data_(:,2) - 1) < eps);
    patch_unit.name = 'North_Face';
    patch_unit.type = 'point';
    patch_unit.id = id;
    this.boundary_patch_{1} = patch_unit;
    
    id = find(abs(this.node_data_(:,2)) < eps);
    patch_unit.name = 'South_Face';
    patch_unit.type = 'point';
    patch_unit.id = id;
    this.boundary_patch_{2} = patch_unit;

    id = find(abs(this.node_data_(:,1) - 1) < eps);
    patch_unit.name = 'East_Face';
    patch_unit.type = 'point';
    patch_unit.id = id;
    this.boundary_patch_{3} = patch_unit;
    
    id = find(abs(this.node_data_(:,1)) < eps);
    patch_unit.name = 'West_Face';
    patch_unit.type = 'point';
    patch_unit.id = id;
    this.boundary_patch_{4} = patch_unit;
    
    disp('Domain <Point type> : ');
    disp('>> generated mesh data : UnitSquare!')
    
end

