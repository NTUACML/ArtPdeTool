classdef Element < handle
    %ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        element_node_
        region_
        all_element_type_node_
    end
    
    methods
        function this = Element(region, element_node)
            this.element_node_ = element_node;
            this.region_ = region;
            this.getAllElementTypeNode();
        end
        
        function num_element  = getNumElement(this)
            num_element = this.all_element_type_node_.getLength;
        end
        
        function connectivity  = getConnectivity(this)
            num_element  = this.getNumElement();
            connectivity = cell(num_element, 1);
            for c_i = 0 : num_element - 1
                row_connect_str = char(this.all_element_type_node_.item(c_i).getFirstChild.getData);
                row_connect_cell = strsplit(row_connect_str);
                num_connect = length(row_connect_cell);
                connect = zeros(1, num_connect);
                for j = 1 : num_connect
                    connect(j) = str2double(row_connect_cell{j});
                end
                connectivity{c_i + 1} = connect;
            end
        end
        
        function element_type  = getElementType(this)
            num_element  = this.getNumElement();
            element_type = cell(num_element, 1);
            for c_i = 0 : num_element - 1
                type_str = char(this.all_element_type_node_.item(c_i).getAttribute('value'));
                element_type{c_i + 1} = type_str;
            end
        end
        
        function neighbor  = getNeighbor(this)
            if(strcmp(this.region_, 'Boundary'))
                num_element  = this.getNumElement();
                neighbor = cell(num_element, 1);
                for c_i = 0 : num_element - 1
                    neighbor_str = char(this.all_element_type_node_.item(c_i).getAttribute('neighbor'));
                    neighbor{c_i + 1} = str2double(neighbor_str);
                end
            else
                disp('Error <XML_Loader> - Element!');
                disp('> The ''neighbor'' attribute is only exist on the boundary region!');
                neighbor = [];
            end
        end
    end
    
    methods (Access = private)
        function getAllElementTypeNode(this)
            this.all_element_type_node_ = this.element_node_.getElementsByTagName('Type');
        end
    end
end

