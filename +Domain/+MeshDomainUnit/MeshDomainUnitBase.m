classdef MeshDomainUnitBase < handle
    %MESHDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_node_           % number of node data
        num_element_        % number of element data
        node_data_          % node data
        connect_data_       % connectivity of element
        element_types_      % element type of element
    end
    
    methods
        function this = MeshDomainUnitBase()
            this.num_node_ = 0;
            this.num_element_ = 0;
        end
        
        function NumberUpdate(this)
            this.num_node_ = size(this.node_data_, 1);
            this.num_element_ = size(this.connect_data_, 1);
        end
    end
    
end

