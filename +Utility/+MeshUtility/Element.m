classdef Element < handle
    %CONNECTIVES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        node_id_
        element_type_
    end
    
    methods
        function this = Element(dim, connectivity)
            if(dim == 2)
                this.generateDim2Element(connectivity);
            elseif(dim == 3)
                this.generateDim3Element(connectivity);
            end
        end
        
        function [element_type, node_id] = getElement(this)
            element_type = this.element_type_;
            node_id = this.node_id_;
        end
    end
    
    methods(Access = private)
        function this = generateDim2Element(this, connectivity)
            import Utility.MeshUtility.ElementType
            num_node = length(connectivity);
            if(num_node == 4)
                this.element_type_ = ElementType.Quad4;
            end
            this.node_id_ = connectivity;
        end
        
        function this = generateDim3Element(this, connectivity)
            import Utility.MeshUtility.ElementType
            num_node = length(connectivity);
            if(num_node == 8)
                this.element_type_ = ElementType.Hexa8;
            end
            this.node_id_ = connectivity;
        end
    end
    
end

