classdef QueryUnitRKPM < FunctionSpace.QueryUnit.QueryUnitBase
    %QUARRYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = QueryUnitRKPM()
            this@FunctionSpace.QueryUnit.QueryUnitBase();
        end
        
        function setQuery(this, position)
            this.position_ = position;
        end
    end
end

