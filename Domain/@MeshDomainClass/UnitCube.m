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
    this.boundary_patch_ = cell(size(this.boundary_connectivities_, 1), 2);
    for i = 1 : size(this.boundary_connectivities_, 1)
        this.boundary_element_types_{i} = ElementType.Quad4;
    end
    % Patch definition
    this.boundary_patch_{1,1} = 'Down_Side'; % Patch name
    this.boundary_patch_{1,2} = 'boundary_element'; % Patch type
    this.boundary_patch_{1,3} = [1]; % Patch unit id
   
    this.boundary_patch_{2,1} = 'Up_Side';
    this.boundary_patch_{2,2} = 'boundary_element';
    this.boundary_patch_{2,3} = [2];
    
    this.boundary_patch_{3,1} = 'Rear_Side';
    this.boundary_patch_{3,2} = 'boundary_element';
    this.boundary_patch_{3,3} = [3];
    
    this.boundary_patch_{4,1} = 'Right_Side';
    this.boundary_patch_{4,2} = 'boundary_element';
    this.boundary_patch_{4,3} = [4];
    
    this.boundary_patch_{5,1} = 'Front_Side';
    this.boundary_patch_{5,2} = 'boundary_element';
    this.boundary_patch_{5,3} = [5];
    
    this.boundary_patch_{6,1} = 'Left_Side';
    this.boundary_patch_{6,2} = 'boundary_element';
    this.boundary_patch_{6,3} = [6];
    
    this.boundary_patch_{7,1} = 'Origin';
    this.boundary_patch_{7,2} = 'point';
    this.boundary_patch_{7,3} = [1];
    
    
    disp('Domain <Mesh type> : ');
    disp('>> generated mesh data : UnitCube!')
end

