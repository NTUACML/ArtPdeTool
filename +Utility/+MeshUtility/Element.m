classdef Element < handle
    %CONNECTIVES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_node_ = 0
        node_id_
        element_type_
    end
    
    methods
        function this = Element(dim, node_id)
            this.node_id_ = node_id;
            if(dim == 2)
                this.generateDim2Element(node_id);
            elseif(dim == 3)
                this.generateDim3Element(node_id);
            end
        end
    end
    
    methods(Access = private)
        function this = generateDim2Element(this, node_id)
            import Utility.MeshUtility.ElementType
            this.num_node_ = length(node_id);
            if(this.num_node_ == 4)
                this.element_type_ = ElementType.Quad4;
            end
        end
        
        function this = generateDim3Element(this, node_id)
            import Utility.MeshUtility.ElementType
            this.num_node_ = length(node_id);
            if(this.num_node_ == 8)
                this.element_type_ = ElementType.Hexa8;
            end
        end
    end
    
end

