function status = generateFEM_shapefunction(this, generate_parameter)
%GENERATEFEM_SHAPEFUNCTION Summary of this function goes here
%   Detailed explanation goes here
    import BasisFunction.FEM.ShapeFunction

    status = false;
    
    domain_patch = this.topology_data_.domain_patch_data_;
    num_element = domain_patch.num_element_; 
    num_data = 2; % 1. non_zero_id % 2. evaluate_basis
    
    this.FEM_shapefunction_ = cell(num_element, num_data);
    
    % generate shape function data
    for i = 1 : num_element
    	element = domain_patch.element_data_{i};
        non_zero_id = element.node_id_;
        eval_sf = ...
        	ShapeFunction.MappingElementType2ShapeFunction( element.element_type_ );
        % 1. non_zero_id
        this.FEM_shapefunction_{i, 1} = non_zero_id;
        % 2. evaluate_basis
        this.FEM_shapefunction_{i, 2} = eval_sf;
    end
    
    % check data
    status = true;
end

