classdef Constraint < Constraint.ConstraintBase
    %CONSTRAINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Constraint(patch)
            this@Constraint.ConstraintBase(patch);
        end
        
        function status = generate(this, variable, constraint_data, genetrate_parameter)
            % get constraint_var
            this.constraint_var_ = variable;
            % get constraint_var_id 
            this.constraint_var_id_ = this.getPatchPrescribedVarId();
            
            if(length(constraint_data) <= 2 ...
               && constraint_data{1} <= variable.num_dof_)
                % get constraint_data
                this.constraint_data_ = constraint_data;
                status = true;
            else
                disp('Error <FEM Constraint>! check Constraint data!');
                disp('> Please check constraint_data data is cell type, ');
                disp('> and the first: dof_id, the second: constaint function.');
                status = false;
            end
        end
    end
    
    methods(Access = private)
        function prescribed_var_id = getPatchPrescribedVarId(this)
            patch = this.patch_data_;
            num_element = patch.num_element_;
            tmp_id = [];
            for i_element = 1 : num_element
                element = patch.element_data_{1};
                tmp_id = [tmp_id, element.node_id_];
            end
            unique_tmp_id = unique(tmp_id);
            prescribed_var_id = unique_tmp_id';
        end
        
    end
end

