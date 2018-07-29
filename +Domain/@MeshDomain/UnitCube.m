function UnitCube(this)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.Point
    import Utility.MeshUtility.ElementType
    import Utility.MeshUtility.Patch

    % create interior domain
    domain = this.interior_;
    domain.dim_ = 3;
    % > node data define
    num_node = 8;
    domain.node_data_ = cell(num_node, 1);
    domain.node_data_{1} = Point(3, [0 0 0]);
    domain.node_data_{2} = Point(3, [1 0 0]);
    domain.node_data_{3} = Point(3, [1 1 0]);
    domain.node_data_{4} = Point(3, [0 1 0]);
    domain.node_data_{5} = Point(3, [0 0 1]);
    domain.node_data_{6} = Point(3, [1 0 1]);
    domain.node_data_{7} = Point(3, [1 1 1]);
    domain.node_data_{8} = Point(3, [0 1 1]);
    % > element data define
    num_element = 1;
    domain.element_types_ = cell(num_element,1);
    domain.connect_data_ = cell(num_element,1);
    domain.element_types_{1} = ElementType.Hexa8;
    domain.connect_data_{1} = [1 2 3 4 5 6 7 8];
    
    % create boundary domain
    domain = this.boundary_;
    domain.dim_ = 3;
    % > node data define (same as interior node)
    domain.node_data_ = this.interior_.node_data_;
    % > element data define
    num_element = 6;
    domain.element_types_ = cell(num_element,1);
    domain.connect_data_ = {[1 2 3 4];[5 6 7 8];[1 2 6 5];[2 3 7 6];[3 4 8 7];[1 4 8 5]};
    for i = 1 : num_element
        domain.element_types_{i} = ElementType.Quad4;
    end
    % > patch data define
    num_patch = 7;
    domain.patch_data_ = cell(num_patch,1);
    
    domain.patch_data_{1} = Patch('Down_Side', 'Element', [1]);
    domain.patch_data_{2} = Patch('Up_Side', 'Element', [2]);
    domain.patch_data_{3} = Patch('Rare_Side', 'Element', [3]);
    domain.patch_data_{4} = Patch('Right_Side', 'Element', [4]);
    domain.patch_data_{5} = Patch('Front_Side', 'Element', [5]);
    domain.patch_data_{6} = Patch('Left_Side', 'Element', [6]);
    
    domain.patch_data_{7} = Patch('G_Point', 'Point', [7]);
    
    disp('Domain <Mesh> : ');
    disp('>> generated mesh data : UnitCube!')
end

