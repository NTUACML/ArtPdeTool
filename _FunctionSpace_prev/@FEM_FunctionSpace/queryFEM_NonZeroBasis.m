function [non_zero_basis] = queryFEM_NonZeroBasis(this, q_region, q_id)
%QUARYFEM_NONZEROBASIS Summary of this function goes here
%   Detailed explanation goes here

    import Utility.BasicUtility.Region
    if(q_region == Region.Interior)
        non_zero_basis = this.pre_def_interior{q_id, 1}();
    elseif(q_region == Region.Boundary)
        non_zero_basis = this.pre_def_boundary{q_id, 1}();
    else
        disp('Error<FEM_FunctionSpace> ! Check query unit''s query region!');
        non_zero_basis = [];
    end
    
end

