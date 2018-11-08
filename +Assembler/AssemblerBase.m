classdef AssemblerBase < handle
    %ASSEMBLERBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dof_manager_
        num_total_dof_
        lhs_
        rhs_
    end
    
    methods
        function this = AssemblerBase(dof_manager)
            this.dof_manager_ = dof_manager;
            this.num_total_dof_ = 0;
        end
        
        function status = generate(this)
            this.num_total_dof_ = this.dof_manager_.num_total_dof_;
            
            this.lhs_ = zeros(this.num_total_dof_, this.num_total_dof_);
            this.rhs_ = zeros(this.num_total_dof_, 1);
            
            status = true;
        end
        
        function clear(this)
            this.lhs_ = [];
            this.rhs_ = [];
            this.num_total_dof_ = 0;
        end
    end
    
    methods(Abstract)
        status = Assembly(this, type, var, basis_id, data);
    end
    
    
    
end

