classdef IntegrationRuleClass < handle
    %INTEGRATIONRULECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_int_unit_   % number of interal unit
        int_unit_       % interal unit
    end
    
    methods
        % constructor
        function this = IntegrationRuleClass()
            this.num_int_unit_ = 0;
            this.int_unit_ = [];
        end
        
        % !!!(virtual function)!!!
        % generate integration rule by sub-class definition.
        function status = generate(this, varargin)
            status = logical(true);
        end
        
        function [int_unit] = quarry(this, quarry_unit, varargin)
            int_unit = [];
        end
    end
    
end

