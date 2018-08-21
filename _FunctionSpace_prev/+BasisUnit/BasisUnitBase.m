classdef BasisUnitBase < handle
    %BASISUNITBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id_         % basis id
        is_boundary % is boundary basis? (bool)
    end
    
    methods
        function this = BasisUnitBase(id)
            this.id_ = id;
            this.is_boundary = false;
        end
    end
    
end

