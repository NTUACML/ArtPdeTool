classdef PatchBuilder
    %PATCHBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function patch = create(format, patch_node)
            import Utility.Resources.XML_Loader.XML_DataParser.Patch.*
            switch format
                case 'FEM'
                    patch = FEM.Patch(patch_node);
                case 'NURBS'
                    patch = NURBS.Patch(patch_node);
                otherwise  
                	disp('Error <XML_Loader> - PatchBuilder>! check patch input type!');
                    disp('> empty patch builded!');
                	patch = [];
            end
        end
    end
    
end

