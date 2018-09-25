classdef QueryUnit < handle
    %QUERYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_element_id_
        non_zero_id_
        evaluate_basis_
    end
    
    methods
        function this = QueryUnit(patch_element_id)
            this.patch_element_id_ = patch_element_id;
        end
    end
    
end

