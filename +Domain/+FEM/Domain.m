classdef Domain < Domain.DomainBase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Domain()
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
                % new the variable
                var = Variable(name, basis);
                % generate the variable by type
                status = var.generate(type, type_parameter);
                % check status and add to DOF mannger
                if(status)
                    % DM
                    this.dof_manager_.addVariable(var);
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
            
                genetrated_status = test_variable.generate(genetrate_var);
            
                % error check
            else
                disp('Error <FEM Domain>! check basis input type!');
                disp('> empty test variable builded!');
                test_variable = [];
            end
        end
        
        function constraint = generateConstraint(this, patch, variable, constraint_data, varargin)
            import Utility.BasicUtility.Region
            if(isa(patch, 'Utility.MeshUtility.MeshPatch') ...
                    && (patch.region_ == Region.Boundary)...
                    && isa(variable, 'Variable.Variable'))
                import Constraint.FEM.Constraint
                
                constraint = Constraint(patch);
                % generate constraint
                num_genetrate_var = length(varargin);
                if(num_genetrate_var == 0)
                    genetrate_var = [];
                else
                    genetrate_var = varargin{1};  
                end
                genetrated_status = constraint.generate(variable, constraint_data, genetrate_var);
                
                if(genetrated_status)
                    this.num_constraint_ = this.num_constraint_ + 1;
                    this.constraint_(this.num_constraint_) = constraint;
                else
                    disp('Error <FEM Domain>! - generateConstraint!');
                    disp('> generated fail! please check it~');
                    constraint = [];
                end
                
            else
                disp('Error <FEM Domain>! - generateConstraint!');
                disp('> Please check patch data is boundary patch and Mesh type, ');
                disp('> var is Variable type.');
                constraint = [];
            end
            
        end
        
        function status = calIntegral(this, patch, expression, varargin)
            % Check input data
            if(isa(patch, 'Utility.BasicUtility.Patch') ...
               && ...
               isa(expression, 'Expression.ExpressionBase'))
                import IntegrationRule.FEM.IntegrationRule
                % create integration rule
                int_rule = IntegrationRule(patch, expression);
                % generate integration rule
                num_genetrate_var = length(varargin);
                if(num_genetrate_var == 0)
                    genetrate_var = [];
                else
                    genetrate_var = varargin{1};  
                end
                
                genetrated_status = int_rule.generate(genetrate_var);
                
                if(genetrated_status)
                    this.num_integration_rule_ = this.num_integration_rule_ + 1;
                    this.integration_rule_(this.num_integration_rule_) = int_rule;
                    status = true;
                else
                    disp('Error <FEM Domain>! - calIntegral!');
                    disp('> generated fail! please check it~');
                    status = false;
                end
            else
                disp('Error <FEM Domain>! - calIntegral!');
                disp('> Please check Patch data and Expression type, ');
                disp('> No integration rule created.');
                status = false;
            end
        end
        
        function status = setMapping(this, basis, varargin)
            if(isa(basis, 'BasisFunction.BasisFunctionBase'))
               import Mapping.FEM.Mapping
               this.mapping_ = Mapping(basis);
               status = true;
            else
                disp('Error <FEM Domain>! - setMapping!');
                disp('> Mapping function should be generated by valid basis.');
                status = false;
            end

        end
        
        function status = solve(this, varargin)
            num_solver_parameter = length(varargin);
            if(num_solver_parameter == 0)
            	solver_parameter = [];
            else
            	solver_parameter = varargin{1};  
            end
            
            import Assembler.FEM.Assembler
            % new assembler
            this.assembler_ = Assembler(this.dof_manager_);
            this.assembler_.generate();
            
            % Loop integral rule
            for i_int_rule = 1 : this.num_integration_rule_
                int_rule = this.integration_rule_(i_int_rule);
                int_exp = int_rule.expression_;
                % Loop int unit
                for i_int_unit = 1 : int_rule.num_integral_unit_
                    int_unit = int_rule.integral_unit_{i_int_unit};
                    % Expression evaluate
                    [type, var, basis_id, data] = int_exp.eval(int_unit, this.mapping_)
                end
            end
            
            status = true;
        end
    end
    
end

