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
        
        function debugMode(this)
            str = ['Boundary patch name: ' this.patch_data_.name_];
            disp(str);
            disp('Prescribed dof id:');
            disp(this.constraint_var_id_);
        end
    end
    
    methods(Access = private)
        function prescribed_var_id = getPatchPrescribedVarId(this)
            import BasisFunction.IGA.QueryUnit
            import Utility.BasicUtility.Region

            domain_basis = this.constraint_var_.basis_data_;    
            domain_patch = domain_basis.topology_data_.getDomainPatch();
            domain_nurbs = domain_patch.nurbs_data_;
            sample_pnt = this.patch_data_.nurbs_data_.control_points_(:,1:domain_patch.dim_);
            
            % Find the plane where the control points located
            bool = false(1,size(sample_pnt,2));
            for i = 1:size(sample_pnt,2)
                temp = unique(sample_pnt(:,i));
                if length(temp) == 1
                    bool(i) = true;
                end
            end
            
            boundary_indicator = cell(1, domain_patch.dim_);
            boundary_indicator{bool} = sample_pnt(1, bool);
            
            
            switch domain_patch.dim_
                case 2                    
                    if ~isempty(boundary_indicator{1}) % xi = 0 or xi = 1
                        switch boundary_indicator{1}
                            case 0 % xi = 0
                                id_start = 1;
                            case 1 % xi = 1
                                id_start = domain_nurbs.basis_number_(1);
                        end
                        id_step = domain_nurbs.basis_number_(1);
                        id_end = id_start + id_step*(domain_nurbs.basis_number_(2)-1);                        
                    elseif ~isempty(boundary_indicator{2}) % eta = 0 or eta = 1
                        switch boundary_indicator{2}
                            case 0 % eta = 0
                                id_start = 1;
                            case 1 % eta = 1
                                id_start = 1 + domain_nurbs.basis_number_(1)*(domain_nurbs.basis_number_(2)-1);
                        end
                        id_step = 1;
                        id_end = id_start + id_step*(domain_nurbs.basis_number_(1)-1);
                    end 
                    prescribed_var_id = id_start:id_step:id_end;
                case 3
                    if ~isempty(boundary_indicator{1}) % xi = 0 or xi = 1
                        switch boundary_indicator{1}
                            case 0 % xi = 0
                                id_start = 1;
                            case 1 % xi = 1
                                id_start = domain_nurbs.basis_number_(1);
                        end
                        id_step = domain_nurbs.basis_number_(1);
                        id_end = id_start + id_step*(domain_nurbs.basis_number_(2)*domain_nurbs.basis_number_(3)-1);
                        prescribed_var_id = id_start:id_step:id_end;
                    elseif ~isempty(boundary_indicator{2}) % eta = 0 or eta = 1
                        switch boundary_indicator{2}
                            case 0 % eta = 0
                                id_start = 1:domain_nurbs.basis_number_(1);
                            case 1 % eta = 1
                                id_start = (1:domain_nurbs.basis_number_(1)) + domain_nurbs.basis_number_(1)*(domain_nurbs.basis_number_(2)-1);
                        end
                        id_step = domain_nurbs.basis_number_(1)*domain_nurbs.basis_number_(2);
                        prescribed_var_id = zeros(1,domain_nurbs.basis_number_(3)*domain_nurbs.basis_number_(1));
                        for i = 1:domain_nurbs.basis_number_(3)
                            shift = (i-1)*domain_nurbs.basis_number_(1);
                            prescribed_var_id(shift+1:shift+domain_nurbs.basis_number_(1)) = id_start + (i-1)*id_step;
                        end                        
                    elseif ~isempty(boundary_indicator{3}) % zeta = 0 or zeta = 1
                        switch boundary_indicator{3}
                            case 0 % zeta = 0
                                id_start = 1;
                            case 1 % zeta = 1
                                id_start = 1 + domain_nurbs.basis_number_(1)*domain_nurbs.basis_number_(2)*(domain_nurbs.basis_number_(3)-1);
                        end
                        id_step = 1;
                        id_end = id_start + id_step*(domain_nurbs.basis_number_(1)*domain_nurbs.basis_number_(2)-1); 
                        prescribed_var_id = id_start:id_step:id_end;
                    end
            end

        end
        
    end
end

