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
        
        function domain_dof_id = getDomainDofId(this, var, basis_id, dof_id)
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
                disp('Error <DofMannger> - addVariable!');
                disp('> the variable should be a Variable type.');
            end
        end
    end
    
    
    methods (Access = private)
        function var_data = getVariableData(this, var)
            if(isKey(this.var_data_, var.name_))
                var_data = this.var_data_(var.name_);
            else
                var_data = [];
                disp('Error <DofMannger> - getVariableData!');
                disp('> The variable not existed in DofMannger.');
            end
        end
    end
end

