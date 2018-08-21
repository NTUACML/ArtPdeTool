function [non_zero_basis, basis_value] = queryFEM_FunctionSpace(this, query_unit, procedure)
%QUARYFEM_FUNCTIONSPACE Summary of this function goes here
%   Detailed explanation goes here

    import Utility.BasicUtility.Procedure
    q_region = query_unit.region_;
    q_id = query_unit.element_id_;
    q_xi = query_unit.position_;
    
    if(procedure == Procedure.Preprocess)
        [non_zero_basis] = queryFEM_NonZeroBasis(this, q_region, q_id);
        basis_value = [];
    else
        [non_zero_basis] = queryFEM_NonZeroBasis(this, q_region, q_id);
        [basis_value] = queryFEM_BasisValue(this, q_region, q_id, q_xi);
    end
end

