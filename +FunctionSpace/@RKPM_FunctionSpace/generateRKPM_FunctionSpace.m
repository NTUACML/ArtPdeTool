function generateRKPM_FunctionSpace( this, order, support_size_ratio )
%GENERATEMESHFUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here

    import FunctionSpace.BasisUnit.RKPM.BasisUnit
%     import Utility.PointUtility.ShapeFunction

    interior = this.domain_data_.interior_;
    boundary = this.domain_data_.boundary_;
    
    % build searching tree 
    % TODO KAVY use KD-tree or something instead
    node_set = GetNodeSet(interior);
    this.searching_tree = @ (position) NearestNodeDistance(node_set, position);
    
    % node number equal to the basis number in isoparametric element case.
    this.num_basis_ = interior.num_node_;
    
    % define basis function in the problem.
    this.basis_data_ = cell(this.num_basis_, 1);
    for i = 1 : this.num_basis_
        this.basis_data_{i} = BasisUnit(i);
        this.basis_data_{i}.position_ = interior.node_data_{i};
        this.basis_data_{i}.order_ = order;
        
        [val, ~] = this.searching_tree(this.basis_data_{i}.position_);
        this.basis_data_{i}.support_size_ = val*support_size_ratio;
    end
    
    % define boundary basis function in the problem.
    for i = 1:boundary.num_patch_
        bc_node_id = boundary.patch_data_{i}.data_;     
        this.basis_data_{bc_node_id}.is_boundary = true;
    end
    
    % non_zero_basis and evaluate_basis methods
    this.interior_basis_ = @(quarry_point) find_non_zero_basis_1d(quarry_point, this.domain_data_.node_data_, support);
    this.boundary_basis_ = @(quarry_point) RK_function_1d(quarry_point, this.domain_data_.node_data_, order, support, id);

    disp('FunctionSpace <RKPM> :');
    disp('>> generated function space data !')
end

function node_set = GetNodeSet(domain)
    node_set = zeros(domain.num_node_, domain.dim_);
    for i = 1:domain.num_node_
        node_set(i,:) = domain.node_data_{i}.data_;
    end
end

function [val, id] = NearestNodeDistance(node_set, position)
    dis = zeros(size(node_set, 1), 1);

    for i = 1:size(node_set, 1)
        dis(i) = sumsqr(node_set(i, :) - position.data_);
    end
    
    % exclude self node
    bool = dis < eps;
    dis(bool) = 1^10;
    
    [val, id] = min(dis);
end
