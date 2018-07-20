classdef BoundaryConditionUnitClass < handle
    %BOUNDARYCONDITIONUNITCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        boundary_patch_;
        bc_type_;
        variable_name_;
        coefficient_;
        value_;
        is_described_bc_;
        prescribed_dimension_;
    end
    
    methods
        % constructor
        function this = BoundaryConditionUnitClass(boundary_patch, bc_type, variable)
            this.boundary_patch_ = boundary_patch;
            this.bc_type_ = bc_type;
            this.variable_name_ = variable.name_;
            this.is_described_bc_ = logical(false);
        end
         
        % set coefficient
        function set_coefficient(this, coefficient)
            this.coefficient_ = coefficient;
        end
        
        % set value
        function set_value(this, value)
            this.value_ = value;
        end
        
        % set prescribed
        function set_prescribed_condition_dimention(this, dim)
            if this.boundary_patch_
                this.is_described_bc_ = logical(true);
                this.prescribed_dimension_ = dim;
            end
        end
        
    end
    
end

