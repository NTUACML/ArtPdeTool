classdef BoundaryNurbs < Utility.NurbsUtility.Nurbs
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % orientation of the boundary nurbs 
        % +1 : in 2D problem, the normal is calculated by rotating tangent
        % vector CLOCKWISE
        % -1 : in 2D problem, the normal is calculated by rotating tangent
        % vector COUNTERCLOCKWISE
        orientation_
    end
    
    methods
        function this = BoundaryNurbs(knot_vectors, order, control_point_list, orientation)
            this@Utility.NurbsUtility.Nurbs(knot_vectors, order, control_point_list);
            this.orientation_ = orientation;
        end
    end
    
end

