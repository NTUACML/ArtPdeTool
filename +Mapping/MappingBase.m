classdef MappingBase < handle
    %MAPPINGBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        basis_
    end
    
    methods
        function this = MappingBase(basis)
            this.basis_ = basis;
        end
    end
    
end

