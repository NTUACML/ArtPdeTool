classdef DomainBase < handle
    %DOMAINDASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_
        dof_manager_
        num_constraint_ = 0
        num_integration_rule_ = 0
        num_mapping_ = 0
        constraint_
        integration_rule_
        assembler_
        mapping_
    end
    
    methods
        function this = DomainBase(type)
            % set domain type
            this.type_ = type;
            % Dof Mannger init
            this.dof_manager_ = DofManager.DofManager;
            % Constraint init
            this.constraint_ = containers.Map(...
                'KeyType','double','ValueType','any');
            % IntegrationRule init
            this.integration_rule_ = containers.Map(...
                'KeyType','double','ValueType','any');
            this.mapping_ = containers.Map(...
                'KeyType','double','ValueType','any');
        end
    end
    
    methods (Abstract)
        basis = generateBasis(this, topology, varargin);
        variable = generateVariable(this, name, basis, type, type_parameter, varargin);
        test_variable = generateTestVariable(this, variable, basis, varargin);
        constraint = generateConstraint(this, patch, variable, constraint_data, varargin);
        status = setMapping(this, basis, varargin);
        status = calIntegral(this, patch, expression, varargin);
        %status = cal(this, patch, expression, varargin);
        status = solve(this, varargin);
    end
    
end

