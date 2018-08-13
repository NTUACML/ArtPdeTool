classdef InteriorDomainUnit < handle
    %INTERIORDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_ = 'None'  % interior domain type
        dim_ = 0        % interior domain dimension
    end
    
    methods
        % constructor
        function this = InteriorDomainUnit(type)
            this.type_ = type;
        end
    end
    
end

