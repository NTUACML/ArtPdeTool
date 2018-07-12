classdef FunctionSpaceClass < handle
    %FUNCTIONSPACECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_data_        % Domain data form input
        num_basis_ = 0      % Number of basis function
        basis_              % Basis function information
    end
    
    methods
        % constructor (Input: domain data)
        function this = FunctionSpaceClass(domain)
            this.domain_data_ = domain;
        end
        
        % !!!(virtual function)!!!
        % generate function information by domain data.
        function status = generate(this, varargin)
            status = logical(true);
        end
        
        % !!!(virtual function)!!!
        % quarry basis information by quarry_unit
        % (Input: quarry_unit)
        % (Output: non_zero_basis[function handle], 
        %          evaluate_basis[function handle])
        function [non_zero_basis, evaluate_basis] = quarry(this, quarry_unit, varargin)
            non_zero_basis = [];
            evaluate_basis = [];
        end
        
    end
end

