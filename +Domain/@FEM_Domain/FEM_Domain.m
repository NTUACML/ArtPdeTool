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
        
        function variable = generateVariable(this, name, basis, type, type_parameter, varargin)
            if(isa(basis, 'BasisFunction.BasisFunctionBase'))
                import Variable.Variable
                % get variable number by basis
                num_var = basis.num_basis_;
                % new the variable
                var = Variable(name, num_var);
                % generate the variable by type
                status = var.generate(type, type_parameter);
                % check status and add to DOF mannger
                if(status)
                    % DM
                    this.dof_mannger_.addVariable(var);
                    variable = var;
                else
                    variable = [];
                    disp('Error <FEM Domain>! - generateVariable!');
                    disp('> variable generate error!');
                    disp('> empty variable builded!');
                end
            else
                disp('Error <FEM Domain>! check basis input type!');
                disp('> empty variable builded!');
                variable = [];
            end
        end
        
        function test_variable = generateTestVariable(this, variable, basis, varargin)
            if(isa(variable, 'Variable.Variable') &&... 
               isa(basis, 'BasisFunction.BasisFunctionBase'))
               import TestVariable.TestVariable
                
                % create test variable
                test_variable = TestVariable(variable, basis);
                % generate test variable
                num_genetrate_var = length(varargin);
                if(num_genetrate_var == 0)
                    genetrate_var = [];
                else
                    genetrate_var = varargin{1};  
                end
            
                genetrated_status = basis.generate(genetrate_var);
            
                % error check
            else
                disp('Error <FEM Domain>! check basis input type!');
                disp('> empty test variable builded!');
                test_variable = [];
            end
        end
    end
    
end

