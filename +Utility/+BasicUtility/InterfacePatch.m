classdef InterfacePatch < Utility.BasicUtility.Patch  
    properties
        master_patch_
        slave_patch_
    end
    
    methods
        function this = InterfacePatch(master_patch, slave_patch)                     
            this@Utility.BasicUtility.Patch(master_patch.dim_, 'interface', master_patch.type_, master_patch.region_);
            this.master_patch_ = master_patch;
            this.slave_patch_ = slave_patch; 
        end
    end
end

