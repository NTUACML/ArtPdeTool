classdef MeshInteriorDomainUnit < Domain.MeshDomainUnit.MeshDomainUnitBase & Domain.DomainUnit.InteriorDomainUnit
    %MESHINTERIORDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = MeshInteriorDomainUnit()
            this = this@Domain.DomainUnit.InteriorDomainUnit('Mesh');
            this = this@Domain.MeshDomainUnit.MeshDomainUnitBase();
            disp('Domain <Interior Mesh> : created!')
        end
        
        function disp(this)
            disp('> The mesh type interior domain info: ')
            disp(['Data dimension: ', num2str(this.dim_)])
            disp(['Mesh dimension: ', num2str(this.dim_)])
            disp(['Number of node: ', num2str(this.num_node_)])
            disp(['Number of element: ', num2str(this.num_element_)])
        end
        
        
    end
    
end

