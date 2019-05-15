classdef Domain < Domain.DomainBase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Domain()
            this@Domain.DomainBase('IGA');
        end
        
        function basis = generateBasis(this, topology, varargin)
            import BasisFunction.IGA.BasisFunction
            % create basis function
            basis = BasisFunction.IGA.BasisFunction(topology);
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
                    disp('Error <IGA Domain>! - generateVariable!');
                    disp('> variable generate error!');
                    disp('> empty variable builded!');
                end
            else
                disp('Error <IGA Domain>! check basis input type!');
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
                disp('Error <IGA Domain>! check basis input type!');
                disp('> empty test variable builded!');
                test_variable = [];
            end
        end
        
        function constraint = generateConstraint(this, patch, variable, constraint_data, varargin)
            import Utility.BasicUtility.Region
            if(isa(patch, 'Utility.NurbsUtility.NurbsPatch') ...
                    && (patch.region_ == Region.Boundary)...
                    && isa(variable, 'Variable.Variable'))
                import Constraint.IGA.Constraint
                
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
                    disp('Error <IGA Domain>! - generateConstraint!');
                    disp('> generated fail! please check it~');
                    constraint = [];
                end
                
            else
                disp('Error <IGA Domain>! - generateConstraint!');
                disp('> Please check patch data is boundary patch and Nurbs type, ');
                disp('> var is Variable type.');
                constraint = [];
            end
            
        end
        
        function status = calIntegral(this, patch, expression, mapping, varargin)
            % Check input data
            if(isa(patch, 'Utility.BasicUtility.Patch') ...
               && ...
               isa(expression, 'Expression.ExpressionBase'))
                import IntegrationRule.IGA.IntegrationRule
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
                    
                    this.num_mapping_ = this.num_mapping_ + 1;
                    this.mapping_(this.num_mapping_) = mapping;
                    
                    status = true;
                else
                    disp('Error <IGA Domain>! - calIntegral!');
                    disp('> generated fail! please check it~');
                    status = false;
                end
            else
                disp('Error <IGA Domain>! - calIntegral!');
                disp('> Please check Patch data and Expression type, ');
                disp('> No integration rule created.');
                status = false;
            end
        end
               
        function status = integrate(this, expression, differential, varargin)
            % Check input data
            if(isa(differential, 'Differential.DifferentialBase') ...
               && ...
               isa(expression, 'Expression.ExpressionBase'))
                import IntegrationRule.IGA.IntegrationRule
                % create integration rule
                int_rule = IntegrationRule(differential.patch_, expression);
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
                    
                    this.num_differential_ = this.num_differential_ + 1;
                    this.differential_(this.num_differential_) = differential;
                    status = true;
                else
                    disp('Error <IGA Domain>! - integrate!');
                    disp('> generated fail! please check it~');
                    status = false;
                end
            else
                disp('Error <IGA Domain>! - integrate!');
                disp('> Please check Differential and Expression type, ');
                disp('> No integration rule created.');
                status = false;
            end
        end
                
        function status = setMapping(this, basis, varargin)
            if(isa(basis, 'BasisFunction.BasisFunctionBase'))
               import Mapping.IGA.Mapping
               this.mapping_ = Mapping(basis);
               status = true;
            else
                disp('Error <IGA Domain>! - setMapping!');
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
            
            import Assembler.IGA.Assembler
            import Utility.BasicUtility.AssemblyType
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
                    [type, var, basis_id, data] = int_exp.eval(int_unit, this.differential_(i_int_rule));
                    % Assembly
                    this.assembler_.Assembly(type, var, basis_id, data);
                end
            end
            
            % Loop constraint
            for i_const = 1 : this.num_constraint_
                % get constraint
                constraint_obj = this.constraint_(i_const);
                constraint_var = constraint_obj.constraint_var_;
                constraint_basis_id = constraint_obj.constraint_var_id_;
                % constraint data -> 1. dof_id, 2. constraint value
                num_basis = length(constraint_basis_id); %constraint_obj.patch_data_.nurbs_data_.basis_number_;
                % note that constraint_basis_id is the same as the boundary
                % basis_number only when the constraint is applied to the
                % whole boundary patch
                
%                 length(constraint_basis_id);
                constraint_data = cell(1, num_basis);
                % constraint
                if strcmp(constraint_obj.type_,'collocation')
                    import BasisFunction.IGA.QueryUnit
                    
                    query_unit = QueryUnit();
                    query_unit.query_protocol_{1} = constraint_obj.patch_data_;
                    query_unit.query_protocol_{3} = 0;
                    
                    % generate sample points using the boundary nurbs
                    switch constraint_obj.patch_data_.dim_
                        case 1
                            p_max = max(constraint_obj.patch_data_.nurbs_data_.knot_vectors_{1});
                            p_min = min(constraint_obj.patch_data_.nurbs_data_.knot_vectors_{1});
                            sample_pnt = linspace(p_min, p_max, num_basis);
                            sample_pnt = sample_pnt';
                        case 2
                            p_max = max(constraint_obj.patch_data_.nurbs_data_.knot_vectors_{1});
                            p_min = max(constraint_obj.patch_data_.nurbs_data_.knot_vectors_{1});
                            t_1 = linspace(p_min, p_max, num_basis(1));
                            
                            p_max = max(constraint_obj.patch_data_.nurbs_data_.knot_vectors_{2});
                            p_min = max(constraint_obj.patch_data_.nurbs_data_.knot_vectors_{2});
                            t_2 = linspace(p_min, p_max, num_basis(2));
                            
                            [xx, yy] = meshgrid(t_1, t_2);
                            sample_pnt = [xx(:), yy(:)];
                    end
                    
                    
                    for i = 1:num_basis
                        query_unit.query_protocol_{2} = sample_pnt(i,:);
                        constraint_obj.basis_function_.query(query_unit);
                        
                        non_zero_id = query_unit.non_zero_id_;
                        basis_val = query_unit.evaluate_basis_{1};
                        x_phy = basis_val*constraint_obj.basis_function_.topology_data_.domain_patch_data_.nurbs_data_.control_points_(non_zero_id,1:3);
                        
                        constraint_data{i}.non_zero_id = non_zero_id;
                        constraint_data{i}.coefficient = basis_val;
                        constraint_data{i}.dof = constraint_obj.constraint_data_{1};
                        constraint_data{i}.constraint_value = constraint_obj.constraint_data_{2}(x_phy);
                        constraint_data{i}.type = constraint_obj.type_;
                    end
                else
                    for i = 1:num_basis
                        constraint_data{i}.dof = constraint_obj.constraint_data_{1};
                        constraint_data{i}.constraint_value = constraint_obj.constraint_data_{2}();
                        constraint_data{i}.type = constraint_obj.type_;
                    end
                end
                
                % Assembly
                
                this.assembler_.Assembly(AssemblyType.Constraint,...
                    constraint_var, constraint_basis_id, constraint_data);
            end
            
            % Solve result
            coef = this.assembler_.lhs_ \ this.assembler_.rhs_;
            
            % Result write back
            all_var_name = this.dof_manager_.var_data_.keys();
            num_var = this.dof_manager_.num_var_;
            for i_var = 1 : num_var
                var_data = this.dof_manager_.var_data_(all_var_name{i_var});
                var = var_data{1};
                dof_start = var_data{2};
                dof_end = var_data{3};
                % data write back
                var.data_ = coef(dof_start + 1 : dof_end);
            end
            
            status = true;
        end
    end
    
end

