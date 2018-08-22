classdef MeshPatchBase < handle
    %MESHPATCHBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mesh_dim_ = 0       % the dimension of mesh topology
        num_point_ = 0
        num_element_ = 0    % number of element data
        point_data_
        element_data_       % element data
    end
    
    methods
        function this = MeshPatchBase(dim, num_point, point_data)
            this.mesh_dim_ = dim;
            this.num_point_ = num_point;
            this.point_data_ = point_data;
        end
    end
    
end

