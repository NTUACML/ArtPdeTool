classdef BoundaryElement < Utility.MeshUtility.Element
    %BOUNDARYELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        element_id_;
        orientation_id_;
    end
    
    methods
        function this = BoundaryElement(dim, node_id, element_id)
            this@Utility.MeshUtility.Element(dim, node_id);
            this.element_id_ = element_id;
        end
        
        function generateOrientation(this, domain_patch)
            element_connectivity = domain_patch.element_data_{this.element_id_}.node_id_;
            [~, this.orientation_id_] = ismember(this.node_id_, element_connectivity);
        end
    end
    
end

