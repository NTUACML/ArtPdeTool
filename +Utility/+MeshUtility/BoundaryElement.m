classdef BoundaryElement < Utility.MeshUtility.Element
    %BOUNDARYELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = BoundaryElement(dim, node_id)
            this@Utility.MeshUtility.Element(dim, node_id);
        end
    end
    
end

