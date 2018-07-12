function status = generateMeshFunctionSpace( this, varargin )
%INITMESHFUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here

    % node number equal to the basis number in isoparametric element case.
    this.num_basis_ = this.domain_data_.num_node_;
    
    % define basis function in the problem.
    temp_basis(1:this.num_basis_, 1) = BasisClass();
    this.basis_ = temp_basis;
    
    for i = 1 : this.num_basis_
        % basis id.
        this.basis_(i).id_ = i;
        % feature point in basis function.
        % isoparametric element case is node position.
        this.basis_(i).data_ = @() this.domain_data_.node_data_(i,:);
    end
    
    % pre-calculate mesh type non_zero_basis and evaluate_basis methods
    this.mesh_non_zero_basis_ = cell(this.domain_data_.num_element_, 1);
    this.mesh_evaluate_basis_ = cell(this.domain_data_.num_element_, 1);
    
    for i = 1 : this.domain_data_.num_element_
        % in isoparametric case, non_zero_basis is same as element connectivities.
        this.mesh_non_zero_basis_{i} = @() this.domain_data_.connectivities_{i};
        % mapping element type to shape function handle function.
        this.mesh_evaluate_basis_{i} ...
            = this.MappingMeshType2ShapeFunction(this.domain_data_.element_types_(i));
    end

    status = logical(true);
end

