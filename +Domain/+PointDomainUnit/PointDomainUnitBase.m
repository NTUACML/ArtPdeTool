classdef PointDomainUnitBase < handle
    %MESHDOMAINUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_node_           % number of node data
        node_data_          % node data
    end
    
    methods
        function this = PointDomainUnitBase()
            this.num_node_ = 0;
        end
        
        function NumberUpdate(this)
            this.num_node_ = size(this.node_data_, 1);
        end
    end
    
end

