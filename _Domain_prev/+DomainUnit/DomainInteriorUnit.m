classdef DomainInteriorUnit < handle
    %DOMAININTERIORUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_ = 'None'  % interior domain type
        dim_ = 0        % interior domain dimension
        name_ = 'None'  % interior domain lebal name
    end
    
    methods
        % constructor
        function this = DomainInteriorUnit(type, dim, name)
            this.type_ = type;
            this.dim_ = dim;
            this.name_ = name;
        end
    end
    
end

