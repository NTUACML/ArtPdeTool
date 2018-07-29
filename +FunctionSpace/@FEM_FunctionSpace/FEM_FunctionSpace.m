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
        
        function quarry(this, quarry_unit, varargin)
            
        end
        
    end
    
    methods (Access = {?FunctionSpace.FunctionSpaceBuilder})
        function generate(this, varargin)
            import Utility.BasicUtility.Order
            if(isempty(varargin))
                generateMeshFunctionSpace(this, Order.Linear);
            else
                generateMeshFunctionSpace(this, varargin{1});
            end
        end
    end
    
    methods (Access = private)
        generateMeshFunctionSpace(this, order);
    end
    
end

