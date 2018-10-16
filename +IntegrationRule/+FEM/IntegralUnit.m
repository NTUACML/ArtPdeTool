classdef IntegralUnit < BasisFunction.FEM.QueryUnit
    %INTEGRALUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        int_region_
        int_element_id_
        int_element_data_
        quadrature_
    end
    
    methods
        function this = IntegralUnit(region, element_id, element_data)
            this@BasisFunction.FEM.QueryUnit();
            this.int_region_ = region;
            this.int_element_id_ = element_id;
            this.int_element_data_ = element_data;
            this.query_protocol_ = {this.int_region_, this.int_element_id_};
        end
    end
    
end

