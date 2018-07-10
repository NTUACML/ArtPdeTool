function UnitCube(this)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    this.dim_ = 3;
    this.node_data_ = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
    this.connectivities_ = {[1 2 3 4 5 6 7 8]};
    temp_element_type = ElementType.Hexa8;
    this.element_types_ = temp_element_type;
    this.boundary_connectivities_ = {[1 2 3 4];[5 6 7 8];[1 2 6 5];[2 3 7 6];[3 4 8 7];[1 4 8 5]};
    temp_element_type(1:6,1) = ElementType.Quad4;
    this.boundary_element_types_ = temp_element_type;
  
    disp('Generated mesh data : UnitCube!');
end

