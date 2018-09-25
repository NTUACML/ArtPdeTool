classdef Patch < handle
    %PATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dim_ = 0
        name_ = 'None'
        type_
        region_
    end
    
    methods
        function this = Patch(dim, name, type, region)
            this.dim_ = dim;
            this.name_ = name;
            this.type_ = type;
            this.region_ = region;
        end
        
    end
    
end

