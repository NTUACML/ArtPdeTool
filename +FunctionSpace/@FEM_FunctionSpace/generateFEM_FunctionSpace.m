function generateFEM_FunctionSpace( this, order )
%GENERATEMESHFUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here

    import FunctionSpace.BasisUnit.FEM.BasisUnit
    import Utility.MeshUtility.ShapeFunction

    interior = this.domain_data_.interior_;
    boundary = this.domain_data_.boundary_;

    % node number equal to the basis number in isoparametric element case.
    this.num_basis_ = interior.num_node_;
    
    % define basis function in the problem.
    this.basis_data_ = cell(this.num_basis_, 1);
    for i = 1 : this.num_basis_
        this.basis_data_{i} = BasisUnit(i);
        this.basis_data_{i}.position_ = interior.node_data_{i};
        this.basis_data_{i}.order_ = order;
    end
    
    % define boundary basis function in the problem.
    for i = 1 : boundary.num_element_
        bc_node_id = boundary.connect_data_{i};
        for j = 1 : length(bc_node_id)
            id = bc_node_id(j);
            this.basis_data_{id}.is_boundary = true;
        end
    end
    
    % pre-calculate FEM (interior, boundary) 
    % non_zero_basis and evaluate_basis methods
    this.pre_def_interior = cell(interior.num_element_, 2);
    this.pre_def_boundary = cell(boundary.num_element_, 2);
    % > interior
    for i = 1 : interior.num_element_
        % interior - non_zero_basis
        this.pre_def_interior{i, 1} = @() interior.connect_data_{i};
        % interior - shape_function
        this.pre_def_interior{i, 2} = ...
            ShapeFunction.MappingElementType2ShapeFunction(interior.element_types_{i});
    end
    % > boundary
    for i = 1 : boundary.num_element_
        % boundary - non_zero_basis
        this.pre_def_boundary{i, 1} = @() boundary.connect_data_{i};
        % boundary - shape_function
        this.pre_def_boundary{i, 2} =...
            ShapeFunction.MappingElementType2ShapeFunction(boundary.element_types_{i});
    end
    
    disp('FunctionSpace <FEM> :');
    disp('>> generated function space data !')
end

