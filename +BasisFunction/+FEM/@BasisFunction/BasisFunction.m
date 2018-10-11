classdef BasisFunction < BasisFunction.BasisFunctionBase
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        FEM_shapefunction_ %{1. non_zero_id, 2. evaluate_basis}
    end
    
    methods
        function this = BasisFunction(topology)
            this@BasisFunction.BasisFunctionBase(topology);
        end
        
        function status = generate(this, generate_parameter)
            status = this.generateFEM_shapefunction(generate_parameter);
        end
        
        function results = query(this, query_unit, query_parameter)
            results = this.queryFEM_shapefunction(query_unit, query_parameter);
        end
    end
    
    methods(Access = private)
        status = generateFEM_shapefunction(this, generate_parameter)
        results = queryFEM_shapefunction(this, query_unit, query_parameter)
    end
    
end

