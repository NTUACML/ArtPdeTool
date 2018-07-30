classdef PointBoundaryDomainUnit < Domain.PointDomainUnit.PointDomainUnitBase & Domain.DomainUnit.BoundaryDomainUnit
    %MESHBOUNDARYDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here

    properties
        num_patch_          % number of boundary patch
        patch_data_         % boundary patch data
    end
    
    methods
        function this = PointBoundaryDomainUnit()
            this = this@Domain.DomainUnit.BoundaryDomainUnit('ScatterPoint');
            this = this@Domain.PointDomainUnit.PointDomainUnitBase();
            this.num_patch_ = 0;
            disp('Domain <Boundary Scatter Point> : created!')
        end
        
        function disp(this)
            disp('> The scatter point type boundary domain info: ')
            disp(['Data dimension: ', num2str(this.dim_)])
            disp(['Number of node: ', num2str(this.num_node_)])
            disp(['Number of patch: ', num2str(this.num_patch_)])
        end
        
        function NumberUpdate(this)
            NumberUpdate@Domain.PointDomainUnit.PointDomainUnitBase(this);
            this.num_patch_ = size(this.patch_data_, 1);
        end
    end
    
end

