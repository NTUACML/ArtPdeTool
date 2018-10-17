classdef BasisFunction < BasisFunction.BasisFunctionBase
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        %FEM_shapefunction_ 
        Nurbs_basis_function_ %{1. non_zero_id, 2. evaluate_basis}
    end
    
    methods
        function this = BasisFunction(topology)
            this@BasisFunction.BasisFunctionBase(topology);
        end
        
        function status = generate(this, generate_parameter)
            %status = this.generateFEM_shapefunction(generate_parameter);
           nurbs_data = this.topology_data_.domain_patch_data_.nurbs_data_;
           xi = [0.1 0.2];
           p = nurbs_data.order_;
           knots = nurbs_data.knot_vectors_;
           omega = nurbs_data.control_points_(:,4);
            [ GlobalDof, R, dR_dxi ] = Nurbs_ShapeFunc( xi, p, knots, omega );
            status = true;
        end
        
        function results = query(this, query_unit, query_parameter)
            %results = this.queryFEM_shapefunction(query_unit, query_parameter);
            results = 0;
        end
    end
    
    methods(Access = private)
        status = generateFEM_shapefunction(this, generate_parameter)
        results = queryFEM_shapefunction(this, query_unit, query_parameter)
    end
    
end

