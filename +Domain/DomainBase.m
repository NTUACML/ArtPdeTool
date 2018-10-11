classdef DomainBase < handle
    %DOMAINDASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_
        dof_mannger_
        num_constraint_ = 0
        constraint_
    end
    
    methods
        function this = DomainBase(type)
            import DofMannger.*
            % set domain type
            this.type_ = type;
            % Dof Mannger init
            this.dof_mannger_ = DofMannger();
            % 
            this.constraint_ = containers.Map(...
                'KeyType','double','ValueType','any');
        end
    end
    
    methods (Abstract)
        basis = generateBasis(this, topology, varargin);
        variable = generateVariable(this, name, basis, type, type_parameter, varargin);
        test_variable = generateTestVariable(this, variable, basis, varargin);
        constraint = generateConstraint(this, patch, variable, constraint_data, varargin);
    end
    
end

