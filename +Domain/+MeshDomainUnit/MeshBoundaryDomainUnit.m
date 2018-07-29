classdef MeshBoundaryDomainUnit < Domain.MeshDomainUnit.MeshDomainUnitBase & Domain.DomainUnit.BoundaryDomainUnit
    %MESHBOUNDARYDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here

    properties
        num_patch_          % number of boundary patch
        patch_data_         % boundary patch data
    end
    
    methods
        function this = MeshBoundaryDomainUnit()
            this = this@Domain.DomainUnit.BoundaryDomainUnit('Mesh');
            this = this@Domain.MeshDomainUnit.MeshDomainUnitBase();
            this.num_patch_ = 0;
            disp('Domain <Boundary Mesh> : created!')
        end
        
        function disp(this)
            disp('> The mesh type boundary domain info: ')
            disp(['Data dimension: ', num2str(this.dim_)])
            disp(['Mesh dimension: ', num2str(this.dim_ - 1)])
            disp(['Number of node: ', num2str(this.num_node_)])
            disp(['Number of element: ', num2str(this.num_element_)])
            disp(['Number of patch: ', num2str(this.num_patch_)])
        end
        
        function NumberUpdate(this)
            NumberUpdate@Domain.MeshDomainUnit.MeshDomainUnitBase(this);
            this.num_patch_ = size(this.patch_data_, 1);
        end
    end
    
end

