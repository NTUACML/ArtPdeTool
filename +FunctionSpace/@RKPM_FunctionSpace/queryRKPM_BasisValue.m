function [ basis_value ] = queryFEM_BasisValue( this, q_region, q_id, q_xi )
%QUARYFEM_BASISVALUE Summary of this function goes here
%   Detailed explanation goes here

    import Utility.BasicUtility.Region
    basis_value = cell(2,1);
    if(q_region == Region.Interior)
        [basis_value{1}, basis_value{2}] = this.pre_def_interior{q_id, 2}(q_xi);
    elseif(q_region == Region.Boundary)
        [basis_value{1}, basis_value{2}] = this.pre_def_boundary{q_id, 2}(q_xi);
    else
        disp('Error<FEM_FunctionSpace> ! Check query unit''s query region!');
        basis_value = [];
    end

end

