function StraightLine( this )
%STRAIGHTLINE Summary of this function goes here
%   Detailed explanation goes here

    this.num_node_ = 11; 
    this.num_boundary_node_ = 2;
    this.dim_ = 1;
    this.node_data_ = linspace(0, 1, this.num_node_ )';
    
    this.num_boundary_patch_ = 2;
    
    this.boundary_patch_ = cell(this.num_boundary_node_, 1);
    
    patch_unit.name = 'Left_Point';
    patch_unit.type = 'point';
    patch_unit.id = [1];
    this.boundary_patch_{1} = patch_unit;
    
    patch_unit.name = 'Right_Point';
    patch_unit.type = 'point';
    patch_unit.id = [this.num_node_];
    this.boundary_patch_{2} = patch_unit;

    disp('Domain <Point type> : ');
    disp('>> generated mesh data : StraightLine!')
end

