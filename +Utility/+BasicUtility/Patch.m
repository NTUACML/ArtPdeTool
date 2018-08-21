classdef Patch < handle
    %PATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_dim_ = 0
        patch_name_ = 'None'
        patch_type_
        patch_region_
    end
    
    methods
        function this = Patch(dim, name, type, region)
            this.patch_dim_ = dim;
            this.patch_name_ = name;
            this.patch_type_ = type;
            this.patch_region_ = region;
        end
        
    end
    
end

