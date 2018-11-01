classdef Variable < handle
    %VARIABLE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        name_           % variable name
        type_           % variable type
        basis_data_     % basis data
        num_var_ = 0    % number of variable 
        num_dof_ = 0    % number of degree of freedom (DOF) for each variable
        data_           % variable data stored in each dof cell space
    end
    
    methods
        % constructor
        function this = Variable(name, basis)
            this.name_ = name;
            this.basis_data_ = basis;
            this.num_var_ = this.basis_data_.num_basis_;
        end
        
        function status = generate(this, type, type_parameter)
            status = false;
            import Utility.BasicUtility.VariableType
            
            % new data by type
            if(isa(type, 'Utility.BasicUtility.VariableType'))
                this.type_ = type;
                switch(this.type_)
                    case VariableType.Scalar
                        status = this.newScalarVar(type_parameter);
                    case VariableType.Vector
                        status = this.newVectorVar(type_parameter);
                    otherwise
                        status = false;
                        disp('Error <Variable> - generate!');
                        disp('> Your entery type is not supported now.');
                end
  
            else
                disp('Error <Variable> - generate! check your input type!');
                disp('> the variable input type should be a ''VariableType'' type.');
            end
        end
        
        function var_data = getVarData(this)
            import Utility.BasicUtility.VariableType
            switch(this.type_)
            	case VariableType.Scalar
                    var_data = this.data_;
            	case VariableType.Vector
                    var_data = this.getVectorData();
                otherwise
                	var_data = [];
                	disp('Error <Variable> - getVarData!');
                	disp('> Data type is not supported now.');
            end
        end
        
        function disp(this)
            disp(['The variale name is: ', this.name_]);
            disp(['Number of variable: ', num2str(this.num_var_)]);
            disp(['Number of D.O.F. per variable: ', num2str(this.num_dof_)]);
            disp('The variable data is: ');
            disp(this.getVarData());
        end
        
        function num_total_dof = getTotalDofNum(this)
            num_total_dof = this.num_var_ * this.num_dof_;
        end
        
        function var_dof_id = getVarDofId(this, var_id, dof_id)
            import Utility.BasicUtility.VariableType
            switch(this.type_)
            	case VariableType.Scalar
                    var_dof_id = var_id;
            	case VariableType.Vector
                    var_dof_id = this.getVectorDofId(var_id, dof_id);
                otherwise
                	var_dof_id = [];
                	disp('Error <Variable> - getDofId!');
                	disp('> Data type is not supported now.');
            end
        end
    end
    
    methods (Access = private)
        function status = newScalarVar(this, type_parameter)
            this.num_dof_ = 1;
            num_total_dof = this.num_var_ * this.num_dof_;
            this.data_ = zeros(num_total_dof, 1);
            status = true;
        end
        
        function status = newVectorVar(this, type_parameter)
            if(length(type_parameter) >= 1)
                this.num_dof_ = type_parameter(1);
                num_total_dof = this.getTotalDofNum();
                this.data_ = zeros(num_total_dof, 1);
                status = true;
            else
                disp('Error <Variable> - newVectorVar!');
                disp('> the length of type_parameter should larger than one,');
                disp('> and the meaning for the number is the vector conponent.');
                status = false;
            end 
        end
        
        function vector_data = getVectorData(this)
        	vector_data = zeros(this.num_var_, this.num_dof_);
            num_total_dof = this.getTotalDofNum();
            for i_dof = 1 : this.num_dof_
                id = i_dof:this.num_dof_:num_total_dof;
                vector_data(:, i_dof) = this.data_(id);
            end
        end
        
        function var_dof_id = getVectorDofId(this, var_id, dof_id)
            if(dof_id <= this.num_dof_)
                var_dof_id = this.num_dof_ .* (var_id - 1) + dof_id;
            else
                var_dof_id = [];
                disp('Error <Variable> - getVectorDofId!');
                disp('> the DOF id should smaller than variable dof.');
            end
        	
        end
    end
    

end

