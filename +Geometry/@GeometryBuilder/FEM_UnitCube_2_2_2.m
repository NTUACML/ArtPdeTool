function geometry = FEM_UnitCube_2_2_2(var)
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
    cube_point = [0.0 0.0 0.0;
                  0.5 0.0 0.0;
                  1.0 0.0 0.0;
                  0.0 0.5 0.0;
                  0.5 0.5 0.0;
                  1.0 0.5 0.0;
                  0.0 1.0 0.0;
                  0.5 1.0 0.0;
                  1.0 1.0 0.0;
                  0.0 0.0 0.5;
                  0.5 0.0 0.5;
                  1.0 0.0 0.5;
                  0.0 0.5 0.5;
                  0.5 0.5 0.5;
                  1.0 0.5 0.5;
                  0.0 1.0 0.5;
                  0.5 1.0 0.5;
                  1.0 1.0 0.5;
                  0.0 0.0 1.0;
                  0.5 0.0 1.0;
                  1.0 0.0 1.0;
                  0.0 0.5 1.0;
                  0.5 0.5 1.0;
                  1.0 0.5 1.0;
                  0.0 1.0 1.0;
                  0.5 1.0 1.0;
                  1.0 1.0 1.0
                  ];
    
    topo.point_data_ = PointList(cube_point);
    
    % Get Domain patch
    domain_patch = topo.getDomainPatch();
    
    %> Generate domain element
    domain_patch.num_element_ = 8;
    domain_patch.element_data_ = cell(domain_patch.num_element_, 1);
    %>> define element
    domain_patch.element_data_{1} = Element(domain_patch.dim_, [1 2 5 4 10 11 14 13]);
    domain_patch.element_data_{2} = Element(domain_patch.dim_, [2 3 6 5 11 12 15 14]);
    domain_patch.element_data_{3} = Element(domain_patch.dim_, [4 5 8 7 13 14 17 16]);
    domain_patch.element_data_{4} = Element(domain_patch.dim_, [5 6 9 8 14 15 18 17]);
    domain_patch.element_data_{5} = Element(domain_patch.dim_, [10 11 14 13 19 20 23 22]);
    domain_patch.element_data_{6} = Element(domain_patch.dim_, [11 12 15 14 20 21 24 23]);
    domain_patch.element_data_{7} = Element(domain_patch.dim_, [13 14 17 16 22 23 26 25]);
    domain_patch.element_data_{8} = Element(domain_patch.dim_, [14 15 18 17 23 24 27 26]);
    
    % Create Boundary patch (Down_Side)
    patch = topo.newBoundayPatch('Down_Side');
    %> Generate element
    patch.num_element_ = 4;
    patch.element_data_ = cell(patch.num_element_, 1);

    %>> define element
    element_id = 1;
    neighbor_element_id = 1;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [1 2 5 4], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 2;
    neighbor_element_id = 2;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [2 3 6 5], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 3;
    neighbor_element_id = 3;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [4 5 8 7], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 4;
    neighbor_element_id = 4;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [5 6 9 8], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    % Create Boundary patch (Up_Side)
    patch = topo.newBoundayPatch('Up_Side');
    %> Generate element
    patch.num_element_ = 4;
    patch.element_data_ = cell(patch.num_element_, 1);
    
    element_id = 1;
    neighbor_element_id = 5;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [19 20 23 22], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 2;
    neighbor_element_id = 6;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [20 21 24 23], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 3;
    neighbor_element_id = 7;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [22 23 26 25], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 4;
    neighbor_element_id = 8;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [23 24 27 26], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    % Create Boundary patch (Rare_Side)
    patch = topo.newBoundayPatch('Rare_Side');
    %> Generate element
    patch.num_element_ = 4;
    patch.element_data_ = cell(patch.num_element_, 1);
    
    element_id = 1;
    neighbor_element_id = 3;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [7 8 17 16], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 2;
    neighbor_element_id = 4;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [8 9 18 17], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 3;
    neighbor_element_id = 7;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [16 17 26 25], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 4;
    neighbor_element_id = 8;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [17 18 27 26], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    % Create Boundary patch (Right_Side)
    patch = topo.newBoundayPatch('Right_Side');
    %> Generate element
    patch.num_element_ = 4;
    patch.element_data_ = cell(patch.num_element_, 1);
    
    element_id = 1;
    neighbor_element_id = 2;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [3 6 15 12], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 2;
    neighbor_element_id = 4;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [6 9 18 15], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 3;
    neighbor_element_id = 6;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [12 15 24 21], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 4;
    neighbor_element_id = 8;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [15 18 27 24], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    % Create Boundary patch (Front_Side)
    patch = topo.newBoundayPatch('Front_Side');
    %> Generate element
    patch.num_element_ = 4;
    patch.element_data_ = cell(patch.num_element_, 1);
    
    element_id = 1;
    neighbor_element_id = 1;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [1 2 11 10], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 2;
    neighbor_element_id = 2;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [2 3 12 11], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 3;
    neighbor_element_id = 5;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [10 11 20 19], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 4;
    neighbor_element_id = 6;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [11 12 21 20], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();

    % Create Boundary patch (Left_Side)
    patch = topo.newBoundayPatch('Left_Side');
    %> Generate element
    patch.num_element_ = 4;
    patch.element_data_ = cell(patch.num_element_, 1);
    
    element_id = 1;
    neighbor_element_id = 1;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [1 4 13 10], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 2;
    neighbor_element_id = 3;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [4 7 16 13], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 3;
    neighbor_element_id = 5;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [10 13 22 19], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
    
    element_id = 4;
    neighbor_element_id = 7;
    neighbor_element_data = domain_patch.element_data_{neighbor_element_id};
    patch.element_data_{element_id} = BoundaryElement(patch.dim_, [13 16 25 22], neighbor_element_id, neighbor_element_data);
    patch.element_data_{element_id}.generateOrientation();
end

