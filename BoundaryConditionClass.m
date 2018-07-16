classdef BoundaryConditionClass < handle
    %BOUNDARYCONDITIONCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bc_table_;
    end
    
    methods
        % constructor
        function this = BoundaryConditionClass
            this.bc_table_ = [];
        end
        % add boundary condition interface
        function add_boundary_condition(this, bc_unit)
            this.bc_table_ = [this.bc_table_, bc_unit];
        end
    end
    
end

