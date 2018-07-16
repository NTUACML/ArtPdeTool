classdef BoundaryConditionUnitClass
    %BOUNDARYCONDITIONUNITCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        boundary_patch_;
        bc_type_;
        variable_name_;
    end
    
    methods
        function this = BoundaryConditionUnitClass(boundary_patch, bc_type, variable)
            this.boundary_patch_ = boundary_patch;
            this.bc_type_ = bc_type;
            this.variable_name_ = variable.name_;
        end
    end
    
end

