function geometry = IGA_XML( path )
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
        disp('Error <GeometryBuilder> - IGA_XML');
        disp('> The file format or version is not supported, please check it');
        geometry = [];
        return
    end  
    
    % load unit data
    unit_data = loader.getUnitData();
    
    % unit data check
    if(length(unit_data) < 1)
        disp('Error <GeometryBuilder> - IGA_XML');
        disp('> The geometery unit data should exist at least one data information');
        geometry = [];
        return
    end  
    
    % Generate isoparamtric topology in geometry{1}
    topo = Topology.NurbsTopology(str2double(geo_dim));

    geometry.num_topology_ = 1;
    geometry.topology_data_ = {topo};

    % Get patch
    patch_data = unit_data{1}.getPatchData();
    
    % unit data check
    if(length(patch_data) < 1)
        disp('Error <GeometryBuilder> - IGA_XML');
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
            IGA_XML_LoadDomainPatch(patch_data{i}, topo);
        elseif(strcmp(region, 'Boundary'))
            IGA_XML_LoadBoundaryPatch(patch_data{i}, topo);
        else
        end
        
    end
    
    disp(path)
end

function IGA_XML_LoadDomainPatch(xml_patch, topo)
    import Utility.BasicUtility.PointList
    import Utility.NurbsUtility.Nurbs

	% Get Domain patch
	domain_patch = topo.getDomainPatch();
    
    % ControlPoint info
    CT_PT = xml_patch.getControlPoint();
    topo.point_data_ = PointList(CT_PT);
    
    order = xml_patch.getOrder();
    
    knot_vectors = xml_patch.getKnot();
    
    % Generate domain nurbs
    domain_patch.nurbs_data_ = Nurbs(knot_vectors, order, topo.point_data_);
end

function IGA_XML_LoadBoundaryPatch(xml_patch, topo)
    import Utility.BasicUtility.PointList
    import Utility.NurbsUtility.BoundaryNurbs

	% New Boundary patch
	boundary_patch = topo.newBoundayPatch(xml_patch.getName());
    
    % ControlPoint info
    CT_PT = xml_patch.getControlPoint();
    
    order = xml_patch.getOrder();
    
    knot_vectors = xml_patch.getKnot();
    
    switch boundary_patch.dim_
        case 1
            if any(strcmp({'eta_0', 'xi_1'}, boundary_patch.name_))
                orientation = 1;
            else
                orientation = -1;
            end
        case 2
            if any(strcmp({'xi_1', 'eta_1', 'zeta_1'}, boundary_patch.name_))
                orientation = 1;
            else
                orientation = -1;
            end
    end
    
    % Generate boundary nurbs
    boundary_patch.nurbs_data_ = BoundaryNurbs(knot_vectors, order, PointList(CT_PT), orientation);
end


