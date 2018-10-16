classdef BoundaryElement < Utility.MeshUtility.Element
    %BOUNDARYELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        neighbor_element_data_;
        neighbor_element_id_;
        orientation_;
    end
    
    methods
        function this = BoundaryElement(dim, node_id, neighbor_element_id, neighbor_element_data)
            this@Utility.MeshUtility.Element(dim, node_id);
            this.neighbor_element_id_ = neighbor_element_id;
            this.neighbor_element_data_ = neighbor_element_data;
        end
        
        function generateOrientation(this)
            neighbor_element_data = this.neighbor_element_data_;
            
            [~, orientation_id]  = ismember(this.node_id_, neighbor_element_data.node_id_);

            which_boundary_id = this.identifyWhichBoundary(orientation_id, neighbor_element_data.element_type_);    
            
            import Utility.MeshUtility.Orientation
            this.orientation_ = Orientation(which_boundary_id, orientation_id);
        end
    end
    
    methods(Access=private)
        function which_bdr_id = identifyWhichBoundary(this, orientation_id, neighbor_element_type)
            import Utility.MeshUtility.ElementType
            switch neighbor_element_type
                case ElementType.Hexa8
                    if ismember(orientation_id, [1 2 3 4])
                        which_bdr_id = 1;
                    elseif ismember(orientation_id, [5 6 7 8])
                        which_bdr_id = 2;
                    elseif ismember(orientation_id, [1 5 8 4])
                        which_bdr_id = 3;
                    elseif ismember(orientation_id, [2 3 7 6])
                        which_bdr_id = 4;
                    elseif ismember(orientation_id, [1 2 6 5])
                        which_bdr_id = 5; 
                    elseif ismember(orientation_id, [3 4 8 7])
                        which_bdr_id = 6;    
                    end
                otherwise
                    disp('Input element type error!')
            end
        end
    end
    
end

