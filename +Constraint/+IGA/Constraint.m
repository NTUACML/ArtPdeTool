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
                disp('Error <IGA Constraint>! check Constraint data!');
                disp('> Please check constraint_data data is cell type, ');
                disp('> and the first: dof_id, the second: constaint function.');
                status = false;
            end
        end
    end
    
    methods(Access = private)
        function prescribed_var_id = getPatchPrescribedVarId(this)
            patch = this.patch_data_;
            nurbs_basis = this.constraint_var_.basis_data_;
            
            % Quert at parametric control points
            import BasisFunction.IGA.QueryUnit
            import Utility.BasicUtility.Region
            import Utility.BasicUtility.TensorProduct
            
            % Create tensor product tool
            domain_patch = nurbs_basis.topology_data_.getDomainPatch();
            TD = TensorProduct({domain_patch.nurbs_data_.basis_number_(1) domain_patch.nurbs_data_.basis_number_(2)});
            
            control_points = patch.nurbs_data_.control_points_(:,1:domain_patch.dim_);
            bool = (control_points(1,:) == control_points(end,:));
            if abs(control_points(1, bool) - 1) < eps
                isoline_id =  domain_patch.nurbs_data_.basis_number_(bool);
            else
                isoline_id = 1;
            end
            
            query_unit = QueryUnit();
            
            % Query at first parametric control point
            xi = [control_points(1,1) control_points(1,2)];
            query_unit.query_protocol_ = {Region.Domain, xi, 0};
            nurbs_basis.query(query_unit);
            
            non_zero_id = query_unit.non_zero_id_;
            is_bdr_basis = false(size(non_zero_id));
            
            for i = 1:length(non_zero_id)
                local_id = TD.to_local_index(non_zero_id(i));
                if local_id{bool} == isoline_id
                    is_bdr_basis(i) = true;
                end
            end
            
            non_zero_id = non_zero_id(is_bdr_basis);
            
            id_start = non_zero_id(1);
            id_diff = non_zero_id(2)-non_zero_id(1);
            
            % Query at last parametric control point
            xi = [control_points(end,1) control_points(end,2)];
            query_unit.query_protocol_ = {Region.Domain, xi, 0};
            nurbs_basis.query(query_unit);
            
            non_zero_id = query_unit.non_zero_id_;
            is_bdr_basis = false(size(non_zero_id));
            
            for i = 1:length(non_zero_id)
                local_id = TD.to_local_index(non_zero_id(i));
                if local_id{bool} == isoline_id
                    is_bdr_basis(i) = true;
                end
            end
            
            non_zero_id = non_zero_id(is_bdr_basis);
            id_end = non_zero_id(end);
            
            prescribed_var_id = id_start:id_diff:id_end;
        end
        
    end
end

