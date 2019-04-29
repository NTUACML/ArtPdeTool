classdef DifferentialBase < handle
   
    properties
        basis_
        patch_
    end
    
    methods
        function this = DifferentialBase(basis, patch)
            this.basis_ = basis;
            this.patch_ = patch;
        end
    end
    
end

