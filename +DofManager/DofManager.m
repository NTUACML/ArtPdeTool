classdef DofManager < handle
    %DOFMANNGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_var_ = 0;
        num_total_dof_ = 0;
        var_data_               % (Map - Key: Name, Value: {Var_Obj, start, end}).
    end
    
    methods
        function this = DofManager()
            this.var_data_ = containers.Map(...
                'KeyType','char','ValueType','any');
        end
        
        function status = addVariable(this, var)
            if(isa(var, 'Variable.Variable'))
                if(~isKey(this.var_data_, var.name_))
                    end_num_total_dof_ = this.num_total_dof_...
                                       + var.getTotalDofNum();
                    value = {var, this.num_total_dof_, end_num_total_dof_};
                    this.var_data_(var.name_) = value;
                    this.num_var_ = this.num_var_ + 1;
                    this.num_total_dof_ = end_num_total_dof_;
                    status = true;
                else
                    status = false;
                    disp('Error <DofMannger> - addVariable!');
                    disp('> the variable existed!');
                end
            else
                status = false;
                disp('Error <DofMannger> - addVariable!');
                disp('> the variable should be a Variable type.');
            end 
        end
        
        function var_data = getVariableData(this, var)
            if(isKey(this.var_data_, var.name_))
                var_data = this.var_data_(var.name_);
            else
                var_data = [];
                disp('Error <DofMannger> - getVariableData!');
                disp('> The variable not existed in DofMannger.');
            end
        end
        
        function domain_dof_id = getAssemblyId_by_DofId(this, var, basis_id, dof_id)
            if(isa(var, 'Variable.Variable'))
                var_data = getVariableData(this, var);
                if(~isempty(var_data))
                    var_start_id = var_data{2};
                    domain_dof_id = var_start_id + var.getVarDofId(basis_id, dof_id);
                else
                    domain_dof_id = [];
                end
            else
                domain_dof_id = [];
                disp('Error <DofMannger> - getAssemblyId_by_DofId!');
                disp('> the variable should be a Variable type.');
            end
        end
        
        function domain_dof_id = getAssemblyId(this, var, basis_id)
            if(isa(var, 'Variable.Variable'))
                var_data = getVariableData(this, var);
                if(~isempty(var_data))
                    var_start_id = var_data{2};
                    num_dof = var.num_dof_;
                    num_basis = length(basis_id);
                    domain_dof_id = zeros(num_basis * num_dof, 1);
                    for i = 1 : num_basis
                        id = var_start_id + var.getVarDofId(basis_id(i), (1:num_dof)');
                        count_start = num_dof*i-(num_dof-1);
                        count_end = num_dof*i;
                        domain_dof_id(count_start : count_end, 1) = id;
                    end
                else
                    domain_dof_id = [];
                end
            else
                domain_dof_id = [];
                disp('Error <DofMannger> - getAssemblyId!');
                disp('> the variable should be a Variable type.');
            end
        end
    end
    
end

