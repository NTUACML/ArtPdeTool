classdef IntegralUnit < BasisFunction.IGA.QueryUnit
    %INTEGRALUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        int_region_
        xi_ = []
        unit_span_
        quadrature_
    end
    
    methods
        function this = IntegralUnit(region, unit_span)
            import Utility.BasicUtility.Region
            this@BasisFunction.IGA.QueryUnit();
            this.int_region_ = region;
            this.unit_span_ = unit_span;
            this.query_protocol_ = {this.int_region_, this.xi_};
            if this.int_region_ == Region.Boundary
                this.modifyQueryProtocol();
            end
        end
        
        function setQueryPosition(this, xi)
            this.xi_ = xi; 
            this.query_protocol_ = {this.int_region_, this.xi_};
        end
        
    end
        
     methods (Access=private)   
        function modifyQueryProtocol(this)
            import Utility.BasicUtility.Region        
            this.query_protocol_{1} = Region.Domain;
        end
    end
    
end

