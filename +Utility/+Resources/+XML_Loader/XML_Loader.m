classdef XML_Loader < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        path_
        doc_node_
    end
    
    methods
        function this = XML_Loader(file_path)
            this.path_ = file_path;
            this.doc_node_ = this.loadXML_File();
        end
        
        function unit_data = getUnitData(this)
            all_unit_node = this.doc_node_.getElementsByTagName('Unit');
            num_unit = all_unit_node.getLength;
            unit_data = cell(num_unit, 1);
            import Utility.Resources.XML_Loader.XML_DataParser.Unit
            for c_i = 0 : num_unit - 1
                unit_data{c_i + 1} = Unit(all_unit_node.item(c_i));  
            end
        end
        
        function version = getVersion(this)
            version = char(this.doc_node_.getAttribute('version'));
        end
        
        function format = getFormat(this)
            format = char(this.doc_node_.getAttribute('format'));
        end
    end
    
    methods (Access = protected)
        function doc_node = loadXML_File(this)
            try
               doc = xmlread(this.path_);
               doc_node = doc.getDocumentElement();
            catch
                error('Failed to read XML file %s.',this.path_);
            end
        end
        
        
    end
    
end

