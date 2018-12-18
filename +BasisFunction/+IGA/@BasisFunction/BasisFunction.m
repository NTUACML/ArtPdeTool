classdef BasisFunction < BasisFunction.BasisFunctionBase
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        Nurbs_basis_function_ %{1. non_zero_id, 2. evaluate_basis}
    end
    
    methods
        function this = BasisFunction(topology)
            this@BasisFunction.BasisFunctionBase(topology);
        end
        
        function status = generate(this, generate_parameter)
            import BasisFunction.IGA.NurbsBasisFunction
            nurbs_data = this.topology_data_.domain_patch_data_.nurbs_data_;

            this.Nurbs_basis_function_ = @(xi) NurbsBasisFunction.Nurbs_ShapeFunc( xi, nurbs_data.order_, nurbs_data.knot_vectors_, nurbs_data.control_points_(:,4) );
            status = true;
        end
        
        function results = query(this, query_unit, query_parameter)
            [ GlobalDof, R, dR_dxi ] = this.Nurbs_basis_function_(query_unit.query_protocol_{2});
            query_unit.non_zero_id_ = GlobalDof;
            query_unit.evaluate_basis_ = {R, dR_dxi};
            
            results = true;
        end
    end
 
end

