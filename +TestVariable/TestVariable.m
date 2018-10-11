classdef TestVariable < handle
    %TESTVARIABLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        variable_data_
        basis_data_
    end
    
    methods
        function this = TestVariable(variable, basis)
            this.variable_data_ = variable;
            this.basis_data_ = basis;
        end
        
        function status = generate(this, genetrate_var)
            status = true;
        end
    end
    
end

