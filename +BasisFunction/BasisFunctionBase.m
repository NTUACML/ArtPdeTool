classdef BasisFunctionBase < handle
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        topology_data_;
        num_basis_ = 0;
    end
    
    methods
        function this = BasisFunctionBase(topology)
            if(isa(topology, 'Geometry.Topology.TopologyBase'))
                this.topology_data_ = topology;
                this.num_basis_ = this.topology_data_.point_data_.size();
            else
                this.topology_data_ = [];
                disp('Error <BasisFunctionBase>! check topology input type!');
                disp('> basis function build error!');
            end
        end
    end
    
    methods(Abstract)
        status = generate(this, generate_parameter);
        results = query(this, query_unit, query_parameter);
    end
    
end

