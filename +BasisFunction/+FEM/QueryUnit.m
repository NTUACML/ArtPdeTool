classdef QueryUnit < handle
    %QUERYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        region_
        element_id_
        query_protocol_
        non_zero_id_ = []
        evaluate_basis_ = []
    end
    
    methods
        function this = QueryUnit(region, element_id)
            this.region_ = region;
            this.element_id_ = element_id;
            this.query_protocol_ = {this.region_, this.element_id_};
        end
    end
    
end

