classdef PointInteriorDomainUnit < Domain.PointDomainUnit.PointDomainUnitBase & Domain.DomainUnit.InteriorDomainUnit
    %MESHINTERIORDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = PointInteriorDomainUnit()
            this = this@Domain.DomainUnit.InteriorDomainUnit('ScatterPoint');
            this = this@Domain.PointDomainUnit.PointDomainUnitBase();
            disp('Domain <Interior ScatterPoint> : created!')
        end
        
        function disp(this)
            disp('> The scatter point type interior domain info: ')
            disp(['Data dimension: ', num2str(this.dim_)])
            disp(['Number of node: ', num2str(this.num_node_)])
        end
        
        
    end
    
end

