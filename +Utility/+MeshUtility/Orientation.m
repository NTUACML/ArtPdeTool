classdef Orientation
    %ORIENTATION Summary of this class goes here
    %   id_which_boundary_: id of boundary element consisted in neighbor reference
    %   domain element
    %   orientation_id_: id of boundary verterx in neighbor reference
    %   domain element
    
    properties
        which_boundary_id_
        orientation_id_
    end
    
    methods
        function this = Orientation(which_boundary_id, orientation_id)
            this.which_boundary_id_ = which_boundary_id;
            this.orientation_id_ = orientation_id;
        end
    end
    
end

