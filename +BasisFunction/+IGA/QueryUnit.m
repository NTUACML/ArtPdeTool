classdef QueryUnit < handle
    %QUERYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        query_protocol_      
        non_zero_id_ = []
        evaluate_basis_ = []
    end
    
    methods
        function this = QueryUnit()
            % IGA: {region, xi, content} content cna be either 0 for evaluating value,
            % 1 for evaluating value and derivative, default option is 0
            this.query_protocol_ = {[], [], 0};
        end
    end
    
end

