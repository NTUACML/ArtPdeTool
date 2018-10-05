classdef DomainBase < handle
    %DOMAINDASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_
        dof_mannger_
    end
    
    methods
        function this = DomainBase(type)
            import DofMannger.*
            % set domain type
            this.type_ = type;
            % Dof Mannger init
            this.dof_mannger_ = DofMannger();
        end
    end
    
    methods (Abstract)
        basis = generateBasis(this, topology, varargin);
        variable = generateVariable(this, name, basis, type, type_parameter, varargin);
    end
    
end

