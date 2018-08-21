classdef DomainBoundaryUnit < handle
    %DOMAINBOUNDARYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_ = 'None'  % boundary domain type
        dim_ = 0        % boundary domain dimension
        name_ = 'None'  % boundary domain lebal name
    end
    
    methods
        % constructor
        function this = DomainBoundaryUnit(type, dim, name)
            this.type_ = type;
            this.dim_ = dim;
            this.name_ = name;
        end
    end
    
end

