classdef DomainData < handle
    %DOMAINDATAUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_point_ = 0          % number of point
        num_interior_ = 0       % number of interior patch 
        num_boundary_ = 0       % number of boundary patch 
        points_data_ = []       % point data
        interior_data_ = []     % interior patch data
        boundary_data_ = []     % boundary patch data
    end
    
    methods
        function this = DomainData()
        end
        
        function point = getPoint(this, point_id)
            if(point_id > this.num_point_)
                disp('Error<DomainData> ! Check point_id!');
                point = [];
            else
                point = this.points_data_{point_id};
            end
        end
        
        function interior_patch = getInteriorPatch(this, patch_id)
            if(patch_id > this.num_interior_)
                disp('Error<DomainData> ! Check interior patch_id!');
                interior_patch = [];
            else
                interior_patch = this.interior_data_{patch_id};
            end
        end
        
        function boundary_patch = getBoundaryPatch(this, patch_id)
            if(patch_id > this.boundary_data_)
                disp('Error<DomainData> ! Check boundary patch_id!');
                boundary_patch = [];
            else
                boundary_patch = this.boundary_data_{patch_id};
            end
        end
    end
    
end

