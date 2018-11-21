classdef PatchBase < handle
    %PATCHBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_node_
    end
    
    methods
        function this = PatchBase(patch_node)
            this.patch_node_ = patch_node;
        end
        
        function name = getName(this)
            name = char(this.patch_node_.getAttribute('name'));
        end
        
        function type = getType(this)
            type = char(this.patch_node_.getAttribute('type'));
        end
        
        function region = getRegion(this)
            region = char(this.patch_node_.getAttribute('region'));
        end
    end
    
end

