classdef BoundaryNurbs < Utility.NurbsUtility.Nurbs
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_nurbs_data_ = []
    end
    
    methods
        function this = BoundaryNurbs(knot_vectors, order, control_point_list, domain_nurbs_data)
            this@Utility.NurbsUtility.Nurbs(knot_vectors, order, control_point_list);
            this.domain_nurbs_data_ = domain_nurbs_data;
        end
    end
    
end

