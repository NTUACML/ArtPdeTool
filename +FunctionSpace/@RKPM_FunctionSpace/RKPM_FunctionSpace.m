classdef RKPM_FunctionSpace < FunctionSpace.FunctionSpaceBase
    %FEM_FUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        % RKPM basis functions: { non_zero_basis, evaluate_basis }
        evaluate_basis_functions_
        % searching tree
        searching_tree
    end
    
    methods
        function this = RKPM_FunctionSpace(domain)
            this = this@FunctionSpace.FunctionSpaceBase(domain);
            disp('FunctionSpace <RKPM> : created!');
        end
        
        function [non_zero_basis, basis_value] = query(this, query_unit, varargin)
            if(isa(query_unit, 'FunctionSpace.QueryUnit.RKPM.QueryUnitRKPM'))
                [non_zero_basis, basis_value] = this.evaluate_basis_functions_(query_unit); 
            else
                disp('Error<RKPM_FunctionSpace> ! Check function space input query unit!');
                non_zero_basis = [];
                basis_value = [];
            end
        end 
    end
    
    methods (Access = {?FunctionSpace.FunctionSpaceBuilder})
        function generate(this, varargin)
            import Utility.BasicUtility.Order
            if(isempty(varargin))
                generateRKPM_FunctionSpace(this, {Order.Linear, support_size_ratio});
            else
                generateRKPM_FunctionSpace(this, varargin{1});
            end
        end
    end
    
    methods (Access = private)
        generateRKPM_FunctionSpace(this, order, support);
    end
    
end

