classdef FEM_Domain < Domain.DomainBase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = FEM_Domain()
            this@Domain.DomainBase('FEM');
        end
        
        function basis = generateBasis(this, topology, varargin)
            import BasisFunction.FEM.BasisFunction
            % create basis function
            basis = BasisFunction.FEM.BasisFunction(topology);
            % generate basis
            num_genetrate_var = length(varargin);
            if(num_genetrate_var == 0)
                genetrate_var = [];
            else
                genetrate_var = varargin{1};  
            end
            
            genetrated_status = basis.generate(genetrate_var);
            
            % error check
            
        end
        
        function variable = generateVariable(this, name, num_dof, basis, varargin);
            if(1)
            %if(isa(basis, ' '))
                disp('FEM basis')
                variable = [];
            else
                disp('Error <FEM Domain>! check basis input type!');
                disp('> empty variable builded!');
                variable = [];
            end
        end
    end
    
end

