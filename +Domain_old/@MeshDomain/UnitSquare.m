function UnitSquare(this)
%UNITSQUARE Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.Point
    import Utility.MeshUtility.ElementType
    import Utility.MeshUtility.Patch

    % create interior domain
    % let domain be the reference of this.interior_
    domain = this.interior_;
    domain.dim_ = 2;
    % > node data define
    num_node = 4;
    domain.node_data_ = cell(num_node, 1);
    domain.node_data_{1} = Point(2, [0 0]);
    domain.node_data_{2} = Point(2, [1 0]);
    domain.node_data_{3} = Point(2, [1 1]);
    domain.node_data_{4} = Point(2, [0 1]);

    % > element data define
    num_element = 1;
    domain.element_types_ = cell(num_element,1);
    domain.connect_data_ = cell(num_element,1);
    domain.element_types_{1} = ElementType.Quad4;
    domain.connect_data_{1} = [1 2 3 4];
    
    % create boundary domainM
    % let domain be the reference of this.boundary_
    domain = this.boundary_;
    domain.dim_ = 2;
    % > node data define (same as interior node)
    domain.node_data_ = this.interior_.node_data_;
    % > element data define
    num_element = 4;
    domain.element_types_ = cell(num_element,1);
    domain.connect_data_ = {[1 2];[2 3];[3 4];[4 1]};
    for i = 1 : num_element
        domain.element_types_{i} = ElementType.Line2;
    end
    % > patch data define
    num_patch = 4;
    domain.patch_data_ = cell(num_patch,1);
    
    domain.patch_data_{1} = Patch('Down_Side', 'Element', [1]);
    domain.patch_data_{2} = Patch('Right_Side', 'Element', [2]);
    domain.patch_data_{3} = Patch('Up_Side', 'Element', [3]);
    domain.patch_data_{4} = Patch('Left_Side', 'Element', [4]);
        
    disp('Domain <Mesh> : ');
    disp('>> generated mesh data : UnitSquare!')

end

