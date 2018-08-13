classdef MeshDomainBoundaryUnit < Domain.DomainUnit.DomainBoundaryUnit & Domain.MeshDomainUnit.MeshDomainUnitBase
    %DOMAINBOUNDARYUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        is_point_id_ = false;
        node_to_point_id_;
    end
    
    methods
        function this = MeshDomainBoundaryUnit(dim, name)
            this = this@Domain.DomainUnit.DomainBoundaryUnit('Mesh', dim, name);
            this = this@Domain.MeshDomainUnit.MeshDomainUnitBase();
        end
        
        function point_id = MappingNode2PointIndex(this, node_id)
            if(this.is_point_id_)
                point_id = node_id;
            else
                point_id = this.node_to_point_id_(node_id);
            end
        end
    end
    
end

