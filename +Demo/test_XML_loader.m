clear all; home
%% Setting
path = './XML_DataMaker/ArtPDE_FEM.art_geometry';
import Utility.Resources.XML_Loader.*
%% Load XML
loader = XML_Loader(path);
disp(['File version: ', loader.getVersion(), ', File format: ', loader.getFormat()])
%% Get Unit
unit_data = loader.getUnitData();
%% Get Patch
patch_data = unit_data{1}.getPatchData();

%% Loop Patch
for i = 1 : length(patch_data)
    % patch info
    name = patch_data{i}.getName();
    region = patch_data{i}.getRegion();
    type = patch_data{i}.getType();
    
	disp({name, region, type})
    
    % element info
    element_data = patch_data{i}.getElementData();
    num_element = element_data{1}.getNumElement();
    connectivity = element_data{1}.getConnectivity();
    element_type  = element_data{1}.getElementType();
        
    % print domain data
    if(strcmp(region, 'Domain'))
        % Node info
        node_data = patch_data{i}.getNodeData();
        points = node_data{1}.getPointData();
        disp(points)
        
        for e_i = 1 : num_element
            disp(['connect: ', num2str(connectivity{e_i})])
            disp(['elementType: ', element_type{e_i}])
        end
    else % print boundary data
        neighbor  = element_data{1}.getNeighbor();
        
        for e_i = 1 : num_element
            disp(['connect: ', num2str(connectivity{e_i})])
            disp(['elementType: ', element_type{e_i}])
            disp(['neighbor: ', num2str(neighbor{e_i})])
        end
    end
end

