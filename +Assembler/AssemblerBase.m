classdef AssemblerBase < handle
    %ASSEMBLERBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dof_manager_
        lhs_
        rhs_
    end
    
    methods
        function this = AssemblerBase(dof_manager)
            this.dof_manager_ = dof_manager;
        end
        
        function status = generate(this)
            num_total_dof = this.dof_manager_.num_total_dof_;
            
            this.lhs_ = zeros(num_total_dof, num_total_dof);
            this.rhs_ = zeros(num_total_dof, 1);
            
            status = true;
        end
        
        function clear(this)
            this.lhs_ = [];
            this.rhs_ = [];
        end
    end
    
end

