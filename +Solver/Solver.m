classdef Solver < handle
    %SOLVERBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_
        sol_
        solver_type_
        solver_parameter_
    end
    
    methods
        function this = Solver()
            this.domain_ = [];
            this.sol_ = [];
            this.solver_type_ = [];
            this.solver_parameter_ = [];
        end
        
        function this = generate(this, domain, solver_type, varargin)
            this.domain_ = domain;
            this.solver_type_ = solver_type;
            
            % import solver parameter
            num_solver_parameter = length(varargin);
            if(num_solver_parameter == 0)
                this.solver_parameter_ = [];
            else
                this.solver_parameter_ = varargin{1};
            end
            
            import Assembler.IGA.Assembler
            import Utility.BasicUtility.AssemblyType
            % new assembler
            this.domain_.assembler_ = Assembler(this.domain_.dof_manager_);
            this.domain_.assembler_.generate();
            
            
        end
        
        function status = solve(this)
            import Utility.BasicUtility.SolverType
            switch this.solver_type_
                case SolverType.Standard
                    status = this.standardSolver();
                case SolverType.NonlinearNewton
                    status = this.nonlinearNewtonSolver();
                otherwise
                    disp('Input solver type not found!');
                    status = false;
            end
        end       
    end
    
    methods (Access = private)
        function status = standardSolver(this)         
            % Loop integral rule
            this.expressionAssembler();
            
            % Loop constraint
            this.constraintAssembler();
            
            % Solve result
            this.sol_ = this.domain_.assembler_.lhs_ \ this.domain_.assembler_.rhs_;
            
            % Result write back
            all_var_name = this.domain_.dof_manager_.var_data_.keys();
            num_var = this.domain_.dof_manager_.num_var_;
            for i_var = 1 : num_var
                var_data = this.domain_.dof_manager_.var_data_(all_var_name{i_var});
                var = var_data{1};
                dof_start = var_data{2};
                dof_end = var_data{3};
                % data write back
                var.data_ = this.sol_(dof_start + 1 : dof_end);
            end
            
            status = true;
        end
        
        function status = nonlinearNewtonSolver(this)
            tolerance = this.solver_parameter_{1};
            total_load_steps = this.solver_parameter_{2};
                       
            delta = 1 / total_load_steps;
            
            load_step = 0;
                      
            while (load_step < total_load_steps)                            % Start incremental load loop
                load_step = load_step + 1;
                
                str = ['Load Step: ', num2str(load_step)];
                disp(str);
                
                % Load factor
                factor = load_step*delta;
                
                % Initilize variable
                this.applylPrescribedBC(factor);

                iter_step = 0; 
                res = 1e10;
                while (res > tolerance)                                    % Start iteration loop
                    iter_step = iter_step + 1;
                    
                    % Clear K & F
                    this.clearSystemMatrix();
                    
                    % Loop integral rule
                    this.expressionAssembler();
                    
                    % Loop constraint
                    this.constraintAssembler();
                    
                    % Solve result
                    this.sol_ = this.domain_.assembler_.lhs_ \ this.domain_.assembler_.rhs_;
                    
                    % Update result
                    for var_data = values(this.domain_.dof_manager_.var_data_)
                        var = var_data{1}{1};
                        dof_start = var_data{1}{2};
                        dof_end = var_data{1}{3};
                        
                        var.data_ = var.data_ + this.sol_(dof_start + 1 : dof_end);
                    end

                    % Check convergence
                    if(iter_step > 1)
                        res = max(abs(this.domain_.assembler_.rhs_));
                        
                        if iter_step > 2
                            fprintf(1,'%27d %14.5e \n',iter_step, full(res));
                        else
                            fprintf(1,'\n \t Iter \t  Residual \n');
                            fprintf(1,'%27d %14.5e \n',iter_step, full(res));
                        end
                    end
                end                                                        % End iteration loop
                
            end                                                            % End incremental load loop            
            
            status = true;
        end
        
        function status = clearSystemMatrix(this)
            this.domain_.assembler_.lhs_ = zeros(size(this.domain_.assembler_.lhs_));
            this.domain_.assembler_.rhs_ = zeros(size(this.domain_.assembler_.rhs_));
            
            status = true;
        end
        
        function status = expressionAssembler(this)
            for i_int_rule = 1 : this.domain_.num_integration_rule_
                int_rule = this.domain_.integration_rule_(i_int_rule);
                int_exp = int_rule.expression_;
                % Loop int unit
                for i_int_unit = 1 : int_rule.num_integral_unit_
                    int_unit = int_rule.integral_unit_{i_int_unit};
                    % Expression evaluate
                    [type, var, basis_id, data] = int_exp.eval(int_unit, this.domain_.differential_(i_int_rule));
                    % Assembly
                    this.domain_.assembler_.Assembly(type, var, basis_id, data);
                end
            end
            status = true;
        end
        
        function status = constraintAssembler(this)
            for i_const = 1 : this.domain_.num_constraint_
                % get constraint
                constraint_obj = this.domain_.constraint_(i_const);
                constraint_var = constraint_obj.constraint_var_;
                constraint_basis_id = constraint_obj.constraint_var_id_;
                
                num_basis = length(constraint_basis_id); %constraint_obj.patch_data_.nurbs_data_.basis_number_;
                % note that constraint_basis_id is the same as the boundary
                % basis_number only when the constraint is applied to the
                % whole boundary patch
                
                % constraint data -> 1. dof_id, 2. constraint value
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
                
                import Utility.BasicUtility.SolverType
                if this.solver_type_ == SolverType.NonlinearNewton
                    for i = 1:num_basis
                        constraint_data{i}.constraint_value = 0;
                    end
                end
                
                % Assembly
                import Utility.BasicUtility.AssemblyType
                this.domain_.assembler_.Assembly(AssemblyType.Constraint,...
                    constraint_var, constraint_basis_id, constraint_data);
            end
            
            status = true;
        end
        
        function status = applylPrescribedBC(this, factor)
            for i_const = 1 : this.domain_.num_constraint_
                constraint_obj = this.domain_.constraint_(i_const);
                dof = constraint_obj.constraint_data_{1};
                id = this.domain_.dof_manager_.getAssemblyId_by_DofId(constraint_obj.constraint_var_, constraint_obj.constraint_var_id_, dof);
                constraint_obj.constraint_var_.data_(id) = factor * constraint_obj.constraint_data_{2}();
                
                status = true;
            end
            
        end
        
    end
end

