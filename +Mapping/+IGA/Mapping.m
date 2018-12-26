classdef Mapping < Mapping.MappingBase
    %MAPPING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        points_
    end
    
    methods
        function this = Mapping(basis)
            this@Mapping.MappingBase(basis);
            dim = this.basis_.topology_data_.dim_;
            this.points_ = this.basis_.topology_data_.point_data_(:,1:dim);
        end
        
        function mapping_unit = queryLocalMapping(this, query_unit)
            import Mapping.IGA.MappingUnit
            this.basis_.query(query_unit, []);            
            eval_basis = query_unit.evaluate_basis_;
            non_zero_id = query_unit.non_zero_id_;
            local_pt = this.points_(non_zero_id, :);
            mapping_unit = MappingUnit(local_pt, eval_basis);
        end
    end
    
end

