classdef ConstraintBase < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        patch_data_
        constraint_var_id_
    end
    
    methods
        function this = ConstraintBase()    
        end      
    end
    
    methods (Abstract)
        status = generate(this, patch, generate_parameter);
    end
    
end

