classdef MeshPatch < Utility.BasicUtility.Patch
    %MESHPATCHBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_element_ = 0    % number of element data
        element_data_       % element data
    end
    
    methods
        function this = MeshPatch(dim, name, type, region)
            this@Utility.BasicUtility.Patch(dim, name, type, region)
        end
    end
    
end

