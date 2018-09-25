classdef Geometry < handle
    %GEOMETRY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_point_ = 0
        num_boundary_patch_ = 0
        point_data_
        domain_patch_data_
        boundary_patch_data_
    end
    
    methods
        function this = Geometry()
        end
        
        function this = disp(this)
            disp(['Number of point:', num2str(this.num_point_)]);
            disp(['Number of boundary patch:', num2str(this.num_boundary_patch_)]);
            disp('Interior patch:')
            disp(this.domain_patch_data_)
            for i = 1 : this.num_boundary_patch_
                disp(['Boundary patch:', num2str(i)]);
                disp(this.boundary_patch_data_{i});
            end
        end
    end
    
end

