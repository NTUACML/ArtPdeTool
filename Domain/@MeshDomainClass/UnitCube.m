function UnitCube(this)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    this.dim_ = 3;
    this.node_data_ = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
    this.connectivities_ = {[1 2 3 4 5 6 7 8]};
    this.element_types_ = cell(size(this.connectivities_, 1), 1);
    this.element_types_{1} = ElementType.Hexa8;
    this.boundary_connectivities_ = {[1 2 3 4];[5 6 7 8];[1 2 6 5];[2 3 7 6];[3 4 8 7];[1 4 8 5]};
    this.boundary_element_types_ = cell(size(this.boundary_connectivities_, 1), 1);
%     this.boundary_patch_ = cell(size(this.boundary_connectivities_, 1), 2);
    for i = 1 : size(this.boundary_connectivities_, 1)
        this.boundary_element_types_{i} = ElementType.Quad4;
    end
    % Patch definition
    % TODO consider move boundary_patch data to BoundaryConditionClass
    % 2018/7/16 Jeting
    this.boundary_patch_ = cell(7,1);
    
    patch_unit.name = 'Down_Side';
    patch_unit.type = 'boundary_element';
    patch_unit.id = [1];
    this.boundary_patch_{1} = patch_unit;
    
    patch_unit.name = 'Up_Side';
    patch_unit.type = 'boundary_element';
    patch_unit.id = [2];
    this.boundary_patch_{2} = patch_unit;
    
    patch_unit.name = 'Rare_Side';
    patch_unit.type = 'boundary_element';
    patch_unit.id = [3];
    this.boundary_patch_{3} = patch_unit;
    
    patch_unit.name = 'Right_Side';
    patch_unit.type = 'boundary_element';
    patch_unit.id = [4];
    this.boundary_patch_{4} = patch_unit;
    
    patch_unit.name = 'Front_Side';
    patch_unit.type = 'boundary_element';
    patch_unit.id = [5];
    this.boundary_patch_{5} = patch_unit;
    
    patch_unit.name = 'Left_Side';
    patch_unit.type = 'boundary_element';
    patch_unit.id = [6];
    this.boundary_patch_{6} = patch_unit;
    
    patch_unit.name = 'G_Point';
    patch_unit.type = 'point';
    patch_unit.id = [1];
    this.boundary_patch_{7} = patch_unit; 
    
    disp('Domain <Mesh type> : ');
    disp('>> generated mesh data : UnitCube!')
end

