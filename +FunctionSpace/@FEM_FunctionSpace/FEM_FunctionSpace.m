classdef FEM_FunctionSpace < FunctionSpace.FunctionSpaceBase
    %FEM_FUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        % Pre-defined(FEM interior): { non_zero_basis, evaluate_basis }
        pre_def_interior
        % Pre-defined(FEM boundary): { non_zero_basis, evaluate_basis }
        pre_def_boundary
    end
    
    methods
        function this = FEM_FunctionSpace(domain)
            this = this@FunctionSpace.FunctionSpaceBase(domain);
            disp('FunctionSpace <FEM> : created!');
        end
        
        function [non_zero_basis, basis_value] = query(this, query_unit, varargin)
            if(isa(query_unit, 'FunctionSpace.QueryUnit.FEM.QueryUnit'))
                import Utility.BasicUtility.Procedure
                if(isempty(varargin))
                    [non_zero_basis, basis_value] = ...
                    this.queryFEM_FunctionSpace(query_unit, Procedure.Runtime);
                else
                    [non_zero_basis, basis_value] = ...
                    this.queryFEM_FunctionSpace(query_unit, varargin{1});
                end
                
            else
                disp('Error<FEM_FunctionSpace> ! Check function space input query unit!');
                non_zero_basis = [];
                basis_value = [];
            end
        end 
    end
    
    methods (Access = {?FunctionSpace.FunctionSpaceBuilder})
        function generate(this, varargin)
            import Utility.BasicUtility.Order
            if(isempty(varargin))
                generateFEM_FunctionSpace(this, Order.Linear);
            else
                generateFEM_FunctionSpace(this, varargin{1});
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

