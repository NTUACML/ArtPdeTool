classdef DomainMeshPatch < Utility.BasicUtility.Patch ...
                         & ... 
                         Utility.MeshUtility.MeshPatch.MeshPatchBase
    %INTERIORPATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = DomainMeshPatch(dim, name, num_point, point_data)
            import Utility.BasicUtility.PatchType
            import Utility.BasicUtility.Region
            this@Utility.BasicUtility.Patch(dim, name, PatchType.Mesh, Region.Domain);
            this@Utility.MeshUtility.MeshPatch.MeshPatchBase(dim, num_point, point_data);             
        end
    end
    
end

