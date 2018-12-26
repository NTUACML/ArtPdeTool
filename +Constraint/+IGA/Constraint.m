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
                case 3
                    
            end
            
            prescribed_var_id = id_start:id_step:id_end;
            
%             prescribed_var_id = [];
%             query_unit = QueryUnit();
%                         
%             for i = 1:size(sample_pnt,1)
%                 xi = sample_pnt(i,:);
%                 query_unit.query_protocol_ = {Region.Domain, xi, 0};
%                 domain_basis.query(query_unit);
%                 
%                 bool = (abs(query_unit.evaluate_basis_{1}) > eps);
%                 prescribed_var_id = [prescribed_var_id, query_unit.non_zero_id_(bool)'];
%             end            
%             
%             prescribed_var_id = unique(prescribed_var_id);
            
            
%             TD = TensorProduct(num2cell(domain_patch.nurbs_data_.basis_number_));
%             
%             
%             control_points = patch.nurbs_data_.control_points_(:,1:domain_patch.dim_);
%             
%             plane_indicator.driection = abs(control_points(1,:)-control_points(end,:)) < eps;
%             plane_indicator.value = control_points(plane_indicator.driection);
%              
%             
%             for i = 1:TD.num_()
%             end
                                  
%             boundaryDim = patch.dim_;
%             
%             switch boundaryDim
%                 case 2
%                     
%                 case 3
%                     
%             end
%             control_points = patch.nurbs_data_.control_points_(:,1:domain_patch.dim_);
%             bool = (control_points(1,:) == control_points(end,:));
%             if abs(control_points(1, bool) - 1) < eps
%                 isoline_id =  domain_patch.nurbs_data_.basis_number_(bool);
%             else
%                 isoline_id = 1;
%             end
%             
%             query_unit = QueryUnit();
%             
%             % Query at first parametric control point
%             xi = control_points(1,:);
%             query_unit.query_protocol_ = {Region.Domain, xi, 0};
%             nurbs_basis.query(query_unit);
%             
%             non_zero_id = query_unit.non_zero_id_;
%             is_bdr_basis = false(size(non_zero_id));
%             
%             for i = 1:length(non_zero_id)
%                 local_id = TD.to_local_index(non_zero_id(i));
%                 if local_id{bool} == isoline_id
%                     is_bdr_basis(i) = true;
%                 end
%             end
%             
%             non_zero_id = non_zero_id(is_bdr_basis);
%             
%             id_start = non_zero_id(1);
%             id_diff = non_zero_id(2)-non_zero_id(1);
%             
%             % Query at last parametric control point
%             xi = control_points(end,:);
%             query_unit.query_protocol_ = {Region.Domain, xi, 0};
%             nurbs_basis.query(query_unit);
%             
%             non_zero_id = query_unit.non_zero_id_;
%             is_bdr_basis = false(size(non_zero_id));
%             
%             for i = 1:length(non_zero_id)
%                 local_id = TD.to_local_index(non_zero_id(i));
%                 if local_id{bool} == isoline_id
%                     is_bdr_basis(i) = true;
%                 end
%             end
%             
%             non_zero_id = non_zero_id(is_bdr_basis);
%             id_end = non_zero_id(end);
%             
%             prescribed_var_id = id_start:id_diff:id_end;
        end
        
    end
end

