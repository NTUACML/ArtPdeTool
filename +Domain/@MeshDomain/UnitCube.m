function UnitCube(this)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.*
    import Utility.MeshUtility.*
    import Domain.MeshDomainUnit.*
    import Domain.PointDomainUnit.*
    
    % create domain point data
    this.num_point_ = 8;
    cube_point = [0 0 0;
                  1 0 0;
                  1 1 0;
                  0 1 0;
                  0 0 1;
                  1 0 1;
                  1 1 1;
                  0 1 1];
    
    this.points_data_ = PointList(cube_point);
    
    % create domain interior patch unit
    this.num_interior_ = 1;
    this.interior_data_ = cell(this.num_interior_, 1);
    % -> create interior patch 1
    this.interior_data_{1} = MeshDomainInteriorUnit(3, 'Interior_1');
    % ->> (patch 1) define node
    this.interior_data_{1}.is_point_id_ = true;
    this.interior_data_{1}.node_data_ = this.points_data_{:};
    this.interior_data_{1}.num_node_ = this.interior_data_{1}.node_data_.size();
    % ->> (patch 1) define element
    this.interior_data_{1}.num_element_ = 1;
    this.interior_data_{1}.element_data_ = ...
        cell(this.interior_data_{1}.num_element_, 1);
    % ->>> (patch 1) element input info
    this.interior_data_{1}.element_data_{1} = Element(3, [1 2 3 4 5 6 7 8]);
    
    % create domain boundary patch unit
    this.num_boundary_ = 7;
    this.boundary_data_ = cell(this.num_boundary_, 1);
    mapping_point_2_node_tool = Point2NodeIndexMapping();
    
    % -> create boundary patch 1
    this.boundary_data_{1} = MeshDomainInteriorUnit(3, 'Down_Side');
    bc_unit = this.boundary_data_{1};
    mapping_point_2_node_tool.clear();
    
    % ->> (patch 1) define element
    bc_unit.num_element_ = 1;
    bc_unit.element_data_ = cell(bc_unit.num_element_, 1);
    % ->>> (patch 1) element input info
    global_point_id = [1 2 3 4];
    mapping_point_2_node_tool.addPointId(global_point_id);
    node_id = mapping_point_2_node_tool.getNodeId(global_point_id);
    bc_unit.element_data_{1} = Element(2, node_id);

    % ->> (patch 1) define node
    bc_unit.node_to_point_id_ = mapping_point_2_node_tool.getAllPointId();
    bc_unit.node_data_ = this.points_data_{bc_unit.node_to_point_id_};
    bc_unit.num_node_ = bc_unit.node_data_.size();
    
    % -> boundary patch 1 end
    
    % -> create boundary patch 2
    this.boundary_data_{2} = MeshDomainInteriorUnit(3, 'Up_Side');
    bc_unit = this.boundary_data_{2};
    mapping_point_2_node_tool.clear();
    
    % ->> (patch 2) define element
    bc_unit.num_element_ = 1;
    bc_unit.element_data_ = cell(bc_unit.num_element_, 1);
    % ->>> (patch 2) element input info
    global_point_id = [5 6 7 8];
    mapping_point_2_node_tool.addPointId(global_point_id);
    node_id = mapping_point_2_node_tool.getNodeId(global_point_id);
    bc_unit.element_data_{1} = Element(2, node_id);

    % ->> (patch 2) define node
    bc_unit.node_to_point_id_ = mapping_point_2_node_tool.getAllPointId();
    bc_unit.node_data_ = this.points_data_{bc_unit.node_to_point_id_};
    bc_unit.num_node_ = bc_unit.node_data_.size();
    
    % -> boundary patch 2 end
    
    % -> create boundary patch 3
    this.boundary_data_{3} = MeshDomainInteriorUnit(3, 'Rare_Side');
    bc_unit = this.boundary_data_{3};
    mapping_point_2_node_tool.clear();
    
    % ->> (patch 3) define element
    bc_unit.num_element_ = 1;
    bc_unit.element_data_ = cell(bc_unit.num_element_, 1);
    % ->>> (patch 3) element input info
    global_point_id = [1 2 6 5];
    mapping_point_2_node_tool.addPointId(global_point_id);
    node_id = mapping_point_2_node_tool.getNodeId(global_point_id);
    bc_unit.element_data_{1} = Element(2, node_id);

    % ->> (patch 3) define node
    bc_unit.node_to_point_id_ = mapping_point_2_node_tool.getAllPointId();
    bc_unit.node_data_ = this.points_data_{bc_unit.node_to_point_id_};
    bc_unit.num_node_ = bc_unit.node_data_.size();
    
    % -> boundary patch 3 end
    
    % -> create boundary patch 4
    this.boundary_data_{4} = MeshDomainInteriorUnit(3, 'Right_Side');
    bc_unit = this.boundary_data_{4};
    mapping_point_2_node_tool.clear();
    
    % ->> (patch 4) define element
    bc_unit.num_element_ = 1;
    bc_unit.element_data_ = cell(bc_unit.num_element_, 1);
    % ->>> (patch 4) element input info
    global_point_id = [2 3 7 6];
    mapping_point_2_node_tool.addPointId(global_point_id);
    node_id = mapping_point_2_node_tool.getNodeId(global_point_id);
    bc_unit.element_data_{1} = Element(2, node_id);

    % ->> (patch 4) define node
    bc_unit.node_to_point_id_ = mapping_point_2_node_tool.getAllPointId();
    bc_unit.node_data_ = this.points_data_{bc_unit.node_to_point_id_};
    bc_unit.num_node_ = bc_unit.node_data_.size();
    
    % -> boundary patch 4 end
    
    % -> create boundary patch 5
    this.boundary_data_{5} = MeshDomainInteriorUnit(3, 'Front_Side');
    bc_unit = this.boundary_data_{5};
    mapping_point_2_node_tool.clear();
    
    % ->> (patch 5) define element
    bc_unit.num_element_ = 1;
    bc_unit.element_data_ = cell(bc_unit.num_element_, 1);
    % ->>> (patch 5) element input info
    global_point_id = [3 4 8 7];
    mapping_point_2_node_tool.addPointId(global_point_id);
    node_id = mapping_point_2_node_tool.getNodeId(global_point_id);
    bc_unit.element_data_{1} = Element(2, node_id);

    % ->> (patch 5) define node
    bc_unit.node_to_point_id_ = mapping_point_2_node_tool.getAllPointId();
    bc_unit.node_data_ = this.points_data_{bc_unit.node_to_point_id_};
    bc_unit.num_node_ = bc_unit.node_data_.size();
    
    % -> boundary patch 5 end
    
    % -> create boundary patch 6
    this.boundary_data_{6} = MeshDomainInteriorUnit(3, 'Right_Side');
    bc_unit = this.boundary_data_{6};
    mapping_point_2_node_tool.clear();
    
    % ->> (patch 6) define element
    bc_unit.num_element_ = 1;
    bc_unit.element_data_ = cell(bc_unit.num_element_, 1);
    % ->>> (patch 6) element input info
    global_point_id = [1 4 8 5];
    mapping_point_2_node_tool.addPointId(global_point_id);
    node_id = mapping_point_2_node_tool.getNodeId(global_point_id);
    bc_unit.element_data_{1} = Element(2, node_id);

    % ->> (patch 6) define node
    bc_unit.node_to_point_id_ = mapping_point_2_node_tool.getAllPointId();
    bc_unit.node_data_ = this.points_data_{bc_unit.node_to_point_id_};
    bc_unit.num_node_ = bc_unit.node_data_.size();
    
    % -> boundary patch 6 end
    
    % -> create boundary patch 7
    this.boundary_data_{7} = PointDomainBoundaryUnit(3, 'G_Point');
    bc_unit = this.boundary_data_{7};

    
%     
%     domain.patch_data_{7} = Patch('G_Point', 'Point', [7]);
    
    disp('Domain <Mesh> : ');
    disp('>> generated mesh data : UnitCube!')
end

