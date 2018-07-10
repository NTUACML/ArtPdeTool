classdef MeshDomainDataClass < handle
    %MESHDOMAINDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % fundamental data
        type_ = 'Mesh'
        name_                    % mesh name
        dim_                     % mesh dimension
        num_node_                % number of node data
        num_element_             % number of element data
        num_boundary_element_    % number of boundary element data
        node_data_               % node data (whole mesh)
        connectivities_          % connectivity of element (whole mesh)
        element_types_           % element type of element (whole mesh)
        boundary_connectivities_ % connectivity of boundary element (whole boundary mesh)
        boundary_element_types_  % element type of element (whole boundary mesh)
          
        % specific data
        num_boundary_patch_      % number of boundary patch
        boundary_patch_contents_  % boundary patch contents
    end
    
    methods
        % constructor
        function this = MeshDomainDataClass()
            disp('Mesh data constructed!')
            this.num_node_ = 0;
            this.num_element_ = 0;
            this.num_boundary_element_ = 0;
            this.num_boundary_patch_ = 0;
        end
        
        % generate domain data by name
        function status = generate(this, name)
            % return status
            status = logical(true);
            
            switch name
                case 'UnitCube'
                    this.name_ = 'UnitCube';
                    UnitCube(this);
                case 'StraightLine'
                    this.name_ = 'StraightLine';
                    StraightLine(this);
                otherwise
                    disp('Error! Check mesh input name!');
                    status = logical(false);
            end
            
            % get generated data number
            this.num_node_ = size(this.node_data_, 1);
            this.num_element_ = size(this.connectivities_, 1);
            this.num_boundary_element_ = size(this.boundary_connectivities_, 1);
            this.num_boundary_patch_ = size(this.boundary_patch_contents_, 1);
        end
    end
    
    methods (Access = private)
        UnitCube(this);
        StraightLine(this);
    end
end



