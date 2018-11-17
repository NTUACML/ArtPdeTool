function geometry = FEM_XML( path )
%FEM_XML Summary of this function goes here
%   Detailed explanation goes here

    import Geometry.*
    import Utility.BasicUtility.*
    import Utility.MeshUtility.*
    import Utility.Resources.XML_Loader.*

    % Generate geometry unit
    geometry = Geometry();
    
    % Load XML
    loader = XML_Loader(path);
    xml_version = str2double(loader.getVersion());
    xml_format = loader.getFormat();
    
    % XML format check
    if(~(strcmp(xml_format,'FEM')) || ~(xml_version >= 1.0))
        disp('Error <GeometryBuilder> - FEM_XML');
        disp('> The file format or version is not supported, please check it');
        geometry = [];
        return
    end  
    
    % load unit data
    unit_data = loader.getUnitData();
    
    % unit data check
    if(length(unit_data) < 1)
        disp('Error <GeometryBuilder> - FEM_XML');
        disp('> The geometery unit data should exist at least one data information');
        geometry = [];
        return
    end  

    % Get patch
    patch_data = unit_data{1}.getPatchData();
    
    % unit data check
    if(length(patch_data) < 1)
        disp('Error <GeometryBuilder> - FEM_XML');
        disp('> The patch data should exist at least one data information');
        geometry = [];
        return
    end

    % Generate isoparamtric topology in geometry{1}
    topo = Topology.MeshTopology(3);
    geometry.num_topology_ = 1;
    geometry.topology_data_ = {topo};
    
    % Loop Patch
    for i = 1 : length(patch_data)
        % patch info
        region = patch_data{i}.getRegion();
        
        % Patch shuffle
        if(strcmp(region, 'Domain'))
            FEM_XML_LoadDomainPatch(patch_data{i}, topo);
        elseif(strcmp(region, 'Boundary'))
            FEM_XML_LoadBoundaryPatch(patch_data{i}, topo);
        end
        
    end
    
    
    FEM_XML_LoadDomainPatch()
    
    disp(path)
end

function FEM_XML_LoadDomainPatch(patch, topo)
   disp('hi')
end

function FEM_XML_LoadBoundaryPatch(patch, topo)
   disp('hi')
end
