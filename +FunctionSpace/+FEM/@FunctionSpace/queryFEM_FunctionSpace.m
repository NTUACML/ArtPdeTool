function queryFEM_FunctionSpace( this, query_unit )
%QUERYFEM_FUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here
    query_id = query_unit.patch_element_id_;
    query_unit.non_zero_id_ = this.fem_query_results_{query_id, 1};
    query_unit.evaluate_basis_ = this.fem_query_results_{query_id, 2};
end

