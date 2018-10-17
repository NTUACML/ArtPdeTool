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
            import Utility.BasicUtility.Region
            this@BasisFunction.FEM.QueryUnit();
            this.int_region_ = region;
            this.int_element_id_ = element_id;
            this.int_element_data_ = element_data;          
            this.query_protocol_ = {this.int_region_, this.int_element_id_};
            if this.int_region_ == Region.Boundary
                this.modifyQueryProtocol();
            end
        end
    end
        
     methods (Access=private)   
        function modifyQueryProtocol(this)
            import Utility.BasicUtility.Region        
            this.query_protocol_ = {Region.Domain, this.int_element_data_.neighbor_element_id_};
        end
    end
    
end

