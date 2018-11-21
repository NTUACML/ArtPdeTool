classdef Patch < Utility.Resources.XML_Loader.XML_DataParser.Patch.PatchBase
    %PATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Patch(patch_node)
            this@Utility.Resources.XML_Loader.XML_DataParser.Patch.PatchBase(patch_node)
        end
        
        function control_point = getControlPoint(this)
            all_control_point_node = this.patch_node_.getElementsByTagName('ControlPoint');
            num_control_point_node = all_control_point_node.getLength;
            if(num_control_point_node == 0)
                disp('Error <XML_Loader - IGA> - Patch!');
                disp('> The ''ControlPoint'' data is not exist in NURBS patch.');
                control_point = [];
                return;
            end
            
            CT_PT_node = all_control_point_node.item(0);
            CT_PT_dim_str = char(CT_PT_node.getAttribute('dim'));
            
            if(~isempty(CT_PT_dim_str))
                CT_PT_dim = str2double(CT_PT_dim_str);
                nurbs_dim = CT_PT_dim + 1;
                all_point_node = CT_PT_node.getElementsByTagName('Point');
                num_point = all_point_node.getLength;
                
                control_point = zeros(num_point, nurbs_dim);
                
                for c_i = 0 : num_point - 1
                    row_point_str = char(all_point_node.item(c_i).getFirstChild.getData);
                    row_point_str_cell = strsplit(row_point_str);
                    for j = 1 : nurbs_dim
                        control_point(c_i + 1, j) = str2double(row_point_str_cell{j});
                    end
                end
            else
                disp('Error <XML_Loader - IGA> - Patch!');
                disp('> The ''dim'' attribute in ControlPoint should be assigned!');
                control_point = [];
                return;
            end
        end
        
        function order = getOrder(this)
            all_order_node = this.patch_node_.getElementsByTagName('Order');
            num_order_node = all_order_node.getLength;
            if(num_order_node == 0)
                disp('Error <XML_Loader - IGA> - Patch!');
                disp('> The ''Order'' data is not exist in NURBS patch.');
                order = [];
                return;
            end
            order_node = all_order_node.item(0);
            order_str = char(order_node.getFirstChild.getData);
            order = str2num(order_str);
        end
        
        function knot = getKnot(this)
            all_knot_node = this.patch_node_.getElementsByTagName('Knot');
            num_knot_node = all_knot_node.getLength;
            if(num_knot_node == 0)
                disp('Error <XML_Loader - IGA> - Patch!');
                disp('> The ''Knot'' data is not exist in NURBS patch.');
                knot = [];
                return;
            end
            
            knot_node = all_knot_node.item(0);
            
            all_vector_node = knot_node.getElementsByTagName('Vector');
            num_vector_node = all_vector_node.getLength;
            
            knot = cell(num_vector_node, 1);
            
            for c_i = 0 : num_vector_node - 1
            	row_vector_str = char(all_vector_node.item(c_i).getFirstChild.getData);
                row_vector_str_cell = strsplit(row_vector_str);
                num_value = length(row_vector_str_cell);
                value = zeros(1, num_value);
                for j = 1 : num_value
                    value(j) = str2double(row_vector_str_cell{j});
                end
                knot{c_i + 1} = value;
            end

        end
    end
    
end

