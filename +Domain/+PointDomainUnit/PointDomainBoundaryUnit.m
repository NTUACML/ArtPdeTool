classdef PointDomainBoundaryUnit < Domain.DomainUnit.DomainBoundaryUnit
    %POINTDOMAINBOUNDARYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = PointDomainBoundaryUnit(dim, name)
            this = this@Domain.DomainUnit.DomainBoundaryUnit('Point', dim, name);
        end
    end
    
end

