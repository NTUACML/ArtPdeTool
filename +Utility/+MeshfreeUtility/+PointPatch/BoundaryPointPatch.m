classdef BoundaryPointPatch < Utility.BasicUtility.Patch ...
                         & ... 
                         Utility.MeshfreeUtility.PointPatch.PointPatchBase
    %BOUNDARYPOINTPATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = BoundaryPointPatch(dim, name, num_point, point_data)
            import Utility.BasicUtility.PatchType
            import Utility.BasicUtility.Region
            this@Utility.BasicUtility.Patch(dim, name, PatchType.Point, Region.Boundary);
            this@Utility.MeshfreeUtility.PointPatch.PointPatchBase(num_point, point_data);             
        end
    end
    
end

