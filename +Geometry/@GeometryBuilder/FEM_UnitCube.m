function geometry = FEM_UnitCube(this, var)
%FEM_UNITCUBE Summary of this function goes here
%   Detailed explanation goes here

    import Geometry.*
    import Utility.BasicUtility.*
    import Utility.MeshUtility.*
    
    % Generate geometry unit
    geometry = Geometry();
    
    % Generate isoparamtric topology in geometry{1}
    topo = Topology.MeshTopology(3);
    geometry.num_topology_ = 1;
    geometry.topology_data_ = {topo};
    
    % Generate point data
    cube_point = [0 0 0;
                  1 0 0;
                  1 1 0;
                  0 1 0;
                  0 0 1;
                  1 0 1;
                  1 1 1;
                  0 1 1];
    
    topo.point_data_ = PointList(cube_point);
    
    % Get Domain patch
    domain_patch = topo.getDomainPatch();
    
    %> Generate domain element
    domain_patch.num_element_ = 1;
    domain_patch.element_data_ = cell(domain_patch.num_element_, 1);
    %>> define element
    domain_patch.element_data_{1} = Element(domain_patch.dim_, [1 2 3 4 5 6 7 8]);
    
    % Create Boundary patch (Down_Side)
    patch = topo.newBoundayPatch('Down_Side');
    %> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = BoundaryElement(patch.dim_, [1 2 3 4], 1);
    patch.element_data_{1}.generateOrientation(domain_patch);
    
    % Create Boundary patch (Up_Side)
    patch = topo.newBoundayPatch('Up_Side');
    %> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = BoundaryElement(patch.dim_, [5 6 7 8], 1);
    patch.element_data_{1}.generateOrientation(domain_patch);
    
    % Create Boundary patch (Rare_Side)
    patch = topo.newBoundayPatch('Rare_Side');
    %> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = BoundaryElement(patch.dim_, [1 2 6 5], 1);
    patch.element_data_{1}.generateOrientation(domain_patch);
    
    % Create Boundary patch (Right_Side)
    patch = topo.newBoundayPatch('Right_Side');
    %> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = BoundaryElement(patch.dim_, [2 3 7 6], 1);
    patch.element_data_{1}.generateOrientation(domain_patch);
    
    % Create Boundary patch (Front_Side)
    patch = topo.newBoundayPatch('Front_Side');
    %> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = BoundaryElement(patch.dim_, [3 4 8 7], 1);
    patch.element_data_{1}.generateOrientation(domain_patch);
    
    % Create Boundary patch (Left_Side)
    patch = topo.newBoundayPatch('Left_Side');
    %> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = BoundaryElement(patch.dim_, [1 4 8 5], 1);
    patch.element_data_{1}.generateOrientation(domain_patch);
end

