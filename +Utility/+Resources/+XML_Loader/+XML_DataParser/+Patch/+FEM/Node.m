classdef Node < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        node_node_
    end
    
    methods
        function this = Node(node_node)
            this.node_node_ = node_node;
        end
        
        function dim = getDim(this)
            dim = char(this.node_node_.getAttribute('dim'));
        end
        
        function point_data = getPointData(this)
            dim = this.getDim();
            if(~isempty(dim))
                dim = str2double(dim);
                all_point_node = this.node_node_.getElementsByTagName('Point');
                num_point = all_point_node.getLength;
                
                point_data = zeros(num_point, dim);
                
                for c_i = 0 : num_point - 1
                    row_point_str = char(all_point_node.item(c_i).getFirstChild.getData);
                    row_point_str_cell = strsplit(row_point_str);
                    for j = 1 : dim
                        point_data(c_i + 1, j) = str2double(row_point_str_cell{j});
                    end
                end
            else
                disp('Error <XML_Loader> - Node!');
                disp('> The ''dim'' attribute in Node should be assigned!');
                point_data = [];
            end
        end
    end
    
end

