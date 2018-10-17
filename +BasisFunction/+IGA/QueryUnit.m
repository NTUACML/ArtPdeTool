classdef QueryUnit < handle
    %QUERYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        query_protocol_     % IGA: {region, xi}
        non_zero_id_ = []
        evaluate_basis_ = []
    end
    
    methods
        function this = QueryUnit()
            this.query_protocol_ = {[], []};
        end
    end
    
end

