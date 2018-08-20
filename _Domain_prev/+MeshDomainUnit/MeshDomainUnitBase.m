classdef MeshDomainUnitBase < handle
    %MESHDOMAINUNITBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_node_ = 0       % number of node data
        num_element_ = 0    % number of element data
        node_data_          % node data
        element_data_       % element data
    end
    
    methods
        function this = MeshDomainUnitBase()
        end
    end
    
end

