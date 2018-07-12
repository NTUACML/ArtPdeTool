function StraightLine( this )
%STRAIGHTLINE Summary of this function goes here
%   Detailed explanation goes here

    num_element = 10;
    
    this.dim_ = 1;
    this.node_data_ = linspace(0, 1, num_element + 1)';
    this.connectivities_ = cell(num_element,1);
    for i = 1:num_element
        this.connectivities_{i,1} = [i, i+1];
    end
    temp_element_type(1:num_element,1) = ElementType.Line2;
    this.element_types_ = temp_element_type;
    this.boundary_connectivities_ = {1;num_element+1};
    temp_element_type(1:2,1) = ElementType.Point1;
    this.boundary_element_types_ = temp_element_type;

    disp('Generated mesh data : StraightLine!');
end

