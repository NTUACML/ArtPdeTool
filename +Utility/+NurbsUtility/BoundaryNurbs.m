classdef BoundaryNurbs < Utility.NurbsUtility.Nurbs
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parametric_mapping_
        % records the start and end parametric coordinates of a boundary nurbs.
        % the parametric coordunates are coordinates defined based on the
        % domain nurbs.
        % the purpose of this parametric is desighed to map the parametric
        % coordinates of a boundary nurbs to those of a domain nurbs
    end
    
    methods
        function this = BoundaryNurbs(knot_vectors, order, control_point_list, parametric_mapping)
            this@Utility.NurbsUtility.Nurbs(knot_vectors, order, control_point_list);
            this.parametric_mapping_ = parametric_mapping;
        end
    end
    
end

