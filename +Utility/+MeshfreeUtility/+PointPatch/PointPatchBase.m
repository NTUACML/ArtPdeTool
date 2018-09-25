classdef PointPatchBase < handle
    %POINTPATCHBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_point_ = 0
        num_patch_point_ = 0
        point_data_
        patch_point_id_
    end
    
    methods
        function this = PointPatchBase(num_point, point_data)
            this.num_point_ = num_point;
            this.point_data_ = point_data;
        end
    end
    
end

