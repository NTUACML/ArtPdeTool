classdef MappingBase < handle
   
    properties
        basis_
    end
    
    methods
        function this = MappingBase(basis)
            this.basis_ = basis;
        end
    end
    
end

