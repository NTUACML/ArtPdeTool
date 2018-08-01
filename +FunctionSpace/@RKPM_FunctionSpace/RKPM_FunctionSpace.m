classdef RKPM_FunctionSpace < FunctionSpace.FunctionSpaceBase
    %FEM_FUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        % RKPM interior basis: { non_zero_basis, evaluate_basis }
        interior_basis_
        % RKPM boundary basis: { non_zero_basis, evaluate_basis }
        boundary_basis_
        % searching tree
        searching_tree
    end
    
    methods
        function this = RKPM_FunctionSpace(domain)
            this = this@FunctionSpace.FunctionSpaceBase(domain);
            disp('FunctionSpace <RKPM> : created!');
        end
        
        function [non_zero_basis, basis_value] = query(this, query_unit, varargin)
            if(isa(query_unit, 'FunctionSpace.QueryUnit.RKPM.QueryUnit'))
                import Utility.BasicUtility.Procedure
                if(isempty(varargin))
                    [non_zero_basis, basis_value] = ...
                    this.queryRKPM_FunctionSpace(query_unit, Procedure.Runtime);
                else
                    [non_zero_basis, basis_value] = ...
                    this.queryRKPM_FunctionSpace(query_unit, varargin{1});
                end
                
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
                generateRKPM_FunctionSpace(this, Order.Linear, support_size_ratio);
            else
                generateRKPM_FunctionSpace(this, varargin{1}, varargin{2});
            end
        end
    end
    
    methods (Access = private)
        generateFEM_FunctionSpace(this, order);
        [non_zero_basis, basis_value] = ...
            queryFEM_FunctionSpace(this, query_unit, procedure);
        
        % detial function
        [non_zero_basis] = queryFEM_NonZeroBasis(this, q_region, q_id);
        [basis_value] = queryFEM_BasisValue(this, q_region, q_id, q_xi);
    end
    
end

