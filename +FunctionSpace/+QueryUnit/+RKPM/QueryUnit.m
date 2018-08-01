classdef QueryUnit < FunctionSpace.QueryUnit.QueryUnitBase
    %QUARRYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = QueryUnit()
            this@FunctionSpace.QueryUnit.QueryUnitBase();
        end
        
        function setQuery(this, region, position)
            this.region_ = region;
            this.position_ = position;
        end
    end
end

