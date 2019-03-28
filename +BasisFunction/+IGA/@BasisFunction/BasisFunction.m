classdef BasisFunction < BasisFunction.BasisFunctionBase
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        domain_basis_function_ %{1. non_zero_id, 2. evaluate_basis}
        boundary_basis_function_ %{1. non_zero_id, 2. evaluate_basis}
    end
    
    methods
        function this = BasisFunction(topology)
            this@BasisFunction.BasisFunctionBase(topology);
        end
        
        function status = generate(this, generate_parameter)
            import BasisFunction.IGA.NurbsBasisFunction
            % generate domain basis function
            nurbs_data = this.topology_data_.domain_patch_data_.nurbs_data_;

            this.domain_basis_function_ = ... 
                @(xi, content) NurbsBasisFunction.Nurbs_ShapeFunc( xi, nurbs_data.order_, nurbs_data.knot_vectors_, nurbs_data.control_points_(:,4), content );
            
            % generate boundary basis functions            
            this.boundary_basis_function_ = containers.Map('KeyType','char','ValueType','any');
            
            for patch_key = keys(this.topology_data_.boundary_patch_data_)
                nurbs_data = this.topology_data_.boundary_patch_data_(patch_key{1}).nurbs_data_;
                
                this.boundary_basis_function_(patch_key{1}) = ... 
                    @(xi, content) NurbsBasisFunction.Nurbs_ShapeFunc( xi, nurbs_data.order_, nurbs_data.knot_vectors_, nurbs_data.control_points_(:,4), content );
            end
            
            status = true;
        end
        
        function results = query(this, query_unit, query_parameter)
            import Utility.BasicUtility.Region
            switch query_unit.query_protocol_{1}.region_ 
                case Region.Domain
                    [ GlobalDof, R, dR_dxi ] = this.domain_basis_function_(query_unit.query_protocol_{2}, query_unit.query_protocol_{3});
                    query_unit.non_zero_id_ = GlobalDof;
                    query_unit.evaluate_basis_ = {R, dR_dxi};
                    
                    results = true;
                case Region.Boundary
                    domain_patch = this.topology_data_.domain_patch_data_;
                    boundary_patch = query_unit.query_protocol_{1};
                    
                    boundary_basis_function = this.boundary_basis_function_(boundary_patch.name_);
                    [ GlobalDof, R, ~ ] = boundary_basis_function(query_unit.query_protocol_{2}, 0);
                    
                    % map to domain parametric coordinate 
                    xi = R*boundary_patch.nurbs_data_.control_points_(GlobalDof,:);
                                        
                    % evaluate domain basis functions
                    [ GlobalDof, R, dR_dxi ] = this.domain_basis_function_(xi(1:domain_patch.dim_), query_unit.query_protocol_{3});
                    query_unit.non_zero_id_ = GlobalDof;
                    query_unit.evaluate_basis_ = {R, dR_dxi};
                    
                    results = true;
                otherwise
                    disp('ERROR! Query basis functions at wrong region!');
                    results = false;
            end
            
            
        end
    end
 
end

