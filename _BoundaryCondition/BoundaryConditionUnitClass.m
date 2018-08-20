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
            if strcmp(this.boundary_patch_.type_, 'point') 
                this.is_described_bc_ = logical(true);
                this.prescribed_dimension_ = dim;
                if size(this.value_, 1) ~= 1 && size(this.value_, 1) ~= size(this.boundary_patch_.id)
                    disp('Input value size not equal to ');
                end
            else
                str = ['Prescribed bc does not support ', this.boundary_patch_.name_, ' type patch!'];
                disp(str);
            end
        end
        
    end
    
end

