function StraightLine( this )
%STRAIGHTLINE Summary of this function goes here
%   Detailed explanation goes here

    num_element = 10;
    
    this.dim_ = 1;
    this.node_data_ = linspace(0, 1, num_element + 1)';
    this.connectivities_ = cell(num_element,1);
    this.element_types_ = cell(size(this.connectivities_, 1), 1);
    for i = 1:num_element
        this.connectivities_{i,1} = [i, i+1];
        this.element_types_{i} = ElementType.Line2;
    end
    this.boundary_connectivities_ = {1;num_element+1};
    this.boundary_element_types_ = cell(size(this.boundary_connectivities_, 1), 1);
    this.boundary_patch_ = cell(size(this.boundary_connectivities_, 1), 2);
    for i = 1 : size(this.boundary_connectivities_, 1)
        this.boundary_element_types_{i} = ElementType.Point1;
    end
    
    patch_unit.name = 'Left_Point';
    patch_unit.type = 'point';
    patch_unit.id = [1];
    this.boundary_patch_{1} = patch_unit;
    
    patch_unit.name = 'Right_Point';
    patch_unit.type = 'point';
    patch_unit.id = [this.num_node_];
    this.boundary_patch_{2} = patch_unit;
    
    disp('Domain <Mesh type> : ');
    disp('>> generated mesh data : StraightLine!')
end

