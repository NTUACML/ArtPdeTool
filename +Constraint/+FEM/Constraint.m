classdef Constraint < Constraint.ConstraintBase
    %CONSTRAINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Constraint()
            this@Constraint.ConstraintBase();
        end
        
        function status = generate(this, patch, generate_parameter)
            import Utility.BasicUtility.Region
            if(isa(patch, 'Utility.MeshUtility.MeshPatch') ...
                    && (patch.region_ == Region.Boundary))
                this.patch_data_ = patch;
                this.constraint_var_id_ = this.getPatchPrescribedVarId();
                status = true;
            else
                disp('Error <FEM Constraint>! - generate');
                disp('> Please check patch data is boundary patch and Mesh type.');
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

