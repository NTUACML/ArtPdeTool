classdef ConstraintBase < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_data_
        constraint_var_
        constraint_var_id_
        constraint_data_
    end
    
    methods
        function this = ConstraintBase(patch)
            this.patch_data_ = patch;
        end      
    end
    
    methods (Abstract)
        status = generate(this, variable, constraint_data, genetrate_parameter);
    end
    
end

