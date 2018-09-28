classdef DomainBase < handle
    %DOMAINDASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_
        dof_mannger_
    end
    
    methods
        function this = DomainBase(type)
            this.type_ = type;
        end
    end
    
    methods (Abstract)
        basis = generateBasis(this, geometry, varargin);
        variable = generateVariable(this, name, num_dof, basis, varargin);
    end
    
end

