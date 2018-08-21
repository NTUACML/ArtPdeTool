classdef BoundaryDomainUnit < handle
    %BOUNDARYDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_ = 'None'  % boundary domain type
        dim_ = 0        % boundary domain dimension
    end
    
    methods
        % constructor
        function this = BoundaryDomainUnit(type)
            this.type_ = type;
        end
    end
    
end

