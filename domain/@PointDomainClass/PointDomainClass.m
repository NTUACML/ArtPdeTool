classdef PointDomainClass < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % fundamental data
        name_                    % domain name
        dim_                     % domain dimension
        num_node_                % number of node data
        num_boundary_node_       % number of boundary node data
        node_data_               % node data (whole domain)
        
        % specific data
        num_boundary_patch_      % number of boundary patch
        boundary_patch_          % boundary patch contents
    end
    
    methods
        % constructor
        function this = PointDomainClass()
            disp('Domain <Point type> : created!')
            this.num_node_ = 0;
            this.num_boundary_patch_ = 0;
        end
        % generate domain data by name
        function status = generate(this, name)
            % return status
            status = logical(true);
            
            switch name
                case 'StraightLine'
                    this.name_ = 'StraightLine';
                    StraightLine(this);
                case 'UnitSquare'
                    this.name_ = 'UnitSquare';
                    UnitSquare(this);
                otherwise
                    disp('Error! Check mesh input name!');
                    status = logical(false);
            end
            
            % get generated data number
            this.num_node_ = size(this.node_data_, 1);
            this.num_boundary_patch_ = size(this.boundary_patch_, 1);
        end
    end
    
    methods (Access = private)
        StraightLine(this);
    end
    
end

