classdef TopologyBase < handle
    %TOPOLOGYBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dim_                    % The dimension of this topology zone.
        point_data_             % The total points data in this topology zone.
        domain_patch_data_      % The description for domain patch.
        boundary_patch_data_    % The description for boundary patch 
                                % (Map - {'Char', 'any'}).
    end
    
    methods
        function this = TopologyBase(dim)
            this.dim_ = dim;
        end
    end
    
    methods(Abstract)
        domain_patch = getDomainPatch(this);
        boundary_patch = newBoundayPatch(this, patch_name);
        boundary_patch = getBoundayPatch(this, patch_name);
    end
    
end

