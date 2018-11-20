function geometry = FEM_XML( path )
%FEM_XML Summary of this function goes here
%   Detailed explanation goes here

    import Geometry.*
    import Utility.Resources.XML_Loader.*

    % Generate geometry unit
    geometry = Geometry();
    
    % Load XML
    loader = XML_Loader(path);
    xml_version = str2double(loader.getVersion());
    geo_dim = loader.getDim();
    
    % XML format check
    if(~(xml_version >= 1.0))
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
    
    % Generate isoparamtric topology in geometry{1}
    topo = Topology.MeshTopology(str2double(geo_dim));

    geometry.num_topology_ = 1;
    geometry.topology_data_ = {topo};

    % Get patch
    patch_data = unit_data{1}.getPatchData();
    
    % unit data check
    if(length(patch_data) < 1)
        disp('Error <GeometryBuilder> - FEM_XML');
        disp('> The patch data should exist at least one data information');
        geometry = [];
        return
    end
    
    % Loop Patch
    for i = 1 : length(patch_data)
        % patch info
        region = patch_data{i}.getRegion();
        
        % Patch shuffle
        if(strcmp(region, 'Domain'))
            FEM_XML_LoadDomainPatch(patch_data{i}, topo);
        elseif(strcmp(region, 'Boundary'))
            FEM_XML_LoadBoundaryPatch(patch_data{i}, topo);
        else
        end
        
    end
    
    disp(path)
end

function FEM_XML_LoadDomainPatch(xml_patch, topo)
    import Utility.BasicUtility.PointList
    import Utility.MeshUtility.Element
	% Get Domain patch
	domain_patch = topo.getDomainPatch();
    
    % Node info
    node_data = xml_patch.getNodeData();
    points = node_data{1}.getPointData();
    topo.point_data_ = PointList(points);

    % element info
    element_data = xml_patch.getElementData();
    num_element = element_data{1}.getNumElement();
    connectivity = element_data{1}.getConnectivity();
    
    %> Generate domain element
    domain_patch.num_element_ = num_element;
    domain_patch.element_data_ = cell(domain_patch.num_element_, 1);
    
    %>> define element
    for e_i = 1 : num_element
        domain_patch.element_data_{e_i} = Element(domain_patch.dim_, connectivity{e_i});
    end
end

function FEM_XML_LoadBoundaryPatch(xml_patch, topo)
	import Utility.BasicUtility.PointList
    import Utility.MeshUtility.BoundaryElement
    
	% Get Domain patch
	domain_patch = topo.getDomainPatch();
    
    % Create Boundary patch
    name = xml_patch.getName();
    bc_patch = topo.newBoundayPatch(name);
    
    % element info
    element_data = xml_patch.getElementData();
    num_element = element_data{1}.getNumElement();
    connectivity = element_data{1}.getConnectivity();
    neighbor  = element_data{1}.getNeighbor();
    
    %> Generate domain element
    bc_patch.num_element_ = num_element;
    bc_patch.element_data_ = cell(bc_patch.num_element_, 1);
    
    %>> define element
    for e_i = 1 : num_element
        neighbor_element_id = neighbor{e_i};
        neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
        bc_patch.element_data_{e_i} = BoundaryElement(bc_patch.dim_, connectivity{e_i},...
                                        neighbor_element_id, neighbor_element_data);
    end
    
end


