classdef BoundaryMeshPatch < Utility.BasicUtility.Patch ...
                         & ... 
                         Utility.MeshUtility.MeshPatch.MeshPatchBase
    %BOUNDARYPATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = BoundaryMeshPatch(dim, name, num_point, point_data)
            import Utility.BasicUtility.PatchType
            import Utility.BasicUtility.Region
            this@Utility.BasicUtility.Patch(dim, name, PatchType.Mesh, Region.Boundary);
            this@Utility.MeshUtility.MeshPatch.MeshPatchBase(dim - 1, num_point, point_data);             
        end
    end
    
end

