classdef ConstraintBase < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_data_
    end
    
    methods
        function this = ConstraintBase(patch)
            this.patch_data_ = patch;
        end
    end
    
end

