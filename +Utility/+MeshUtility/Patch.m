classdef Patch
    %PATCH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name_       % patch name
        type_       % patch data type (type: Element, Node)
        data_       % patch data contents
                    %   > (Element: element id)
                    %   > (Node   : node id)
    end
    
    methods
        function this = Patch(name, type, data)
            this.name_ = name;
            this.type_ = type;
            this.data_ = data;
        end
    end
    
end

