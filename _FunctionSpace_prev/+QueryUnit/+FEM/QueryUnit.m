classdef QueryUnit < FunctionSpace.QueryUnit.QueryUnitBase
    %QUARRYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        element_id_    % FEM quarry unit following by the element id.
        region_        % quary region for the FEM function space.
                       % (Region.Interior or Region.Boundary)
    end
    
    methods
        function this = QueryUnit()
            this@FunctionSpace.QueryUnit.QueryUnitBase();
        end
        
        function setQuery(this, region, element_id, xi)
            this.region_ = region;
            this.element_id_ = element_id;
            this.position_ = xi;
        end
    end
    
end

