classdef MeshPatchBase < handle
    %MESHPATCHBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mesh_dim_ = 0       % the dimension of mesh topology 
        num_element_ = 0    % number of element data
        element_data_       % element data
    end
    
    methods
        function this = MeshPatchBase(dim)
            this.mesh_dim_ = dim;
        end
    end
    
end

