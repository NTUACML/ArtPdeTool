function status = generatePointFunctionSpace( this, varargin )
%INITMESHFUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here

    % node number equal to the basis number in isoparametric element case.
    this.num_basis_ = this.domain_data_.num_node_;
    
    % define basis function in the problem.
    this.basis_ = cell(this.num_basis_, 1);
    for i = 1 : this.num_basis_
        this.basis_{i} = BasisClass();
        % basis id.
        this.basis_{i}.id_ = i;
        % feature point in basis function.
        this.basis_{i}.data_ = @() this.domain_data_.node_data_(i,:);
    end
    
    order = varargin{1}{1}{1};
    support = varargin{1}{1}{2};

    this.point_non_zero_basis_ = @(quarry_point) find_non_zero_basis_id(quarry_point, this.domain_data_.node_data_, support);
    this.point_evaluate_basis_ = @(quarry_point, id) RK_function_1d(quarry_point, this.domain_data_.node_data_, order, support, id);
    
    disp('FunctionSpace <Point type> :');
    disp('>> generated function space data !')

    status = logical(true);
end
