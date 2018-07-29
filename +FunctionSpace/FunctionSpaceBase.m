classdef FunctionSpaceBase < handle
    %FUNCTIONSPACEBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_data_        % Domain data form input
        num_basis_          % Number of basis function
        basis_data_         % Basis function information
    end
    
    methods
        % constructor (Input: domain data)
        function this = FunctionSpaceBase(domain)
            this.domain_data_ = domain;
            this.num_basis_ = 0;
        end
    end
    
    methods (Abstract)
        quarry(this, quarry_unit, varargin) % quarry basis info interface
    end
end

