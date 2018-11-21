classdef Unit < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        unit_node_
    end
    
    methods
        function this = Unit(unit_node)
            this.unit_node_ = unit_node;
        end
        
        function patch_data = getPatchData(this)
            unit_format = this.getFormat();
            if(~isempty(unit_format))
                all_patch_node = this.unit_node_.getElementsByTagName('Patch');
                num_patch = all_patch_node.getLength;
                patch_data = cell(num_patch, 1);
                import Utility.Resources.XML_Loader.XML_DataParser.Patch.PatchBuilder
                for c_i = 0 : num_patch - 1
                    patch_data{c_i + 1} = PatchBuilder.create(unit_format,all_patch_node.item(c_i));  
                end
            else
                disp('Error <XML_Loader> - Unit!');
                disp('> The ''type'' attribute in unit should be assigned!');
                patch_data = [];
            end
        end
        
        function feature = getFeature(this)
            feature = char(this.unit_node_.getAttribute('feature'));
        end
        
        function format = getFormat(this)
            format = char(this.unit_node_.getAttribute('format'));
        end
        
    end
    
end

