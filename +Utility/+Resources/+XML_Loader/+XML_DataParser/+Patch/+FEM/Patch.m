classdef Patch < Utility.Resources.XML_Loader.XML_DataParser.Patch.PatchBase
    %PATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Patch(patch_node)
            this@Utility.Resources.XML_Loader.XML_DataParser.Patch.PatchBase(patch_node)
        end
        
        function node_data = getNodeData(this)
            region = this.getRegion();
            if(strcmp(region, 'Domain'))
                all_node_node = this.patch_node_.getElementsByTagName('Node');
                num_node = all_node_node.getLength;
                node_data = cell(num_node, 1);
                import Utility.Resources.XML_Loader.XML_DataParser.Patch.FEM.Node
                for c_i = 0 : num_node - 1
                    node_data{c_i + 1} = Node(all_node_node.item(c_i));  
                end
            else
                disp('Error <XML_Loader> - Patch!');
                disp('> The ''node'' data is only exist in domain region.');
                node_data = [];
            end
        end
        
        function element_data = getElementData(this)
            region = this.getRegion();
            all_element_node = this.patch_node_.getElementsByTagName('Element');
            num_element = all_element_node.getLength;
            element_data = cell(num_element, 1);
            import Utility.Resources.XML_Loader.XML_DataParser.Patch.FEM.Element
            for c_i = 0 : num_element - 1
            	element_data{c_i + 1} = Element(region, all_element_node.item(c_i));  
            end
        end
    end
    
end

