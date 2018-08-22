function geometry = FEM_UnitCube(this, var)
%FEM_UNITCUBE Summary of this function goes here
%   Detailed explanation goes here

    import Geometry.Geometry
    import Utility.BasicUtility.*
    import Utility.MeshUtility.*
    import Utility.MeshfreeUtility.*
    
    % Generate geometry unit
    geometry = Geometry();
    
    % Generate data in geometry{1}
    geo = geometry;
    %> Generate point data
    geo.num_point_ = 8;
    cube_point = [0 0 0;
                  1 0 0;
                  1 1 0;
                  0 1 0;
                  0 0 1;
                  1 0 1;
                  1 1 1;
                  0 1 1];
    
    geo.point_data_ = PointList(cube_point);
    %> Generate interior patch
    geo.interior_patch_data_ = MeshPatch.InteriorMeshPatch(3, 'Interior_1',...
                               geo.num_point_, geo.point_data_);
    patch = geo.interior_patch_data_;
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [1 2 3 4 5 6 7 8]);
    
    %> Generate boundary patch
    geo.num_boundary_patch_ = 7;
    geo.boundary_patch_data_ = cell(geo.num_boundary_patch_, 1);

    % Boundary patch 1
    patch_id = 1;
    geo.boundary_patch_data_{patch_id} = ...
                                       MeshPatch.BoundaryMeshPatch(3, 'Down_Side',...
                                       geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [1 2 3 4]);
    
    % Boundary patch 2
    patch_id = 2;
    geo.boundary_patch_data_{patch_id} = ...
                                       MeshPatch.BoundaryMeshPatch(3, 'Up_Side',...
                                       geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [5 6 7 8]);
    
    % Boundary patch 3
    patch_id = 3;
    geo.boundary_patch_data_{patch_id} = ...
                                       MeshPatch.BoundaryMeshPatch(3, 'Rare_Side',...
                                       geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [1 2 6 5]);
    
    % Boundary patch 4
    patch_id = 4;
    geo.boundary_patch_data_{patch_id} = ...
                                       MeshPatch.BoundaryMeshPatch(3, 'Right_Side',...
                                       geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [2 3 7 6]);
    
    % Boundary patch 5
    patch_id = 5;
    geo.boundary_patch_data_{patch_id} = ...
                                       MeshPatch.BoundaryMeshPatch(3, 'Front_Side',....
                                       geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [3 4 8 7]);
    
    % Boundary patch 6
    patch_id = 6;
    geo.boundary_patch_data_{patch_id} = ...
                                       MeshPatch.BoundaryMeshPatch(3, 'Right_Side',...
                                       geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> Generate element
    patch.num_element_ = 1;
    patch.element_data_ = cell(patch.num_element_, 1);
    %>> define element
    patch.element_data_{1} = Element(patch.mesh_dim_, [1 4 8 5]);
    
    % Boundary patch 7
    patch_id = 7;
    geo.boundary_patch_data_{patch_id} = ...
                                        PointPatch.BoundaryPointPatch(3, 'G_Point',...
                                        geo.num_point_, geo.point_data_);
    patch = geo.boundary_patch_data_{patch_id};
    %>> define Patch Point
    patch.num_patch_point_ = 1;
    patch.patch_point_id_ = [7];
    
    
end

