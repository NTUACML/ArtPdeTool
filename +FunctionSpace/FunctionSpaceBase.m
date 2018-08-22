classdef FunctionSpaceBase < handle
    %FUNCTIONSPACEBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_data_
    end
    
    methods
        function this = FunctionSpaceBase(patch)
            this.patch_data_ = patch;
        end
    end
    
    methods (Abstract)
        query(this, query_unit, varargin)
    end
    
end

