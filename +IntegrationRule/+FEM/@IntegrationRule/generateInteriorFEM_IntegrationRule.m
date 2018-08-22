function generateInteriorFEM_IntegrationRule( this )
%GENERATEINTERIORFEM_INTEGRATIONRULE Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.PatchType
    import IntegrationRule.FEM.IntegralUnit
    import IntegrationRule.FEM.GaussQuadrature
    
    if(this.type_ == PatchType.Mesh)
        this.num_integral_unit_ = this.patch_data_.num_element_;
        this.integral_unit_data_ = cell(this.num_integral_unit_, 1);
        
        for i = 1 : this.num_integral_unit_
            this.integral_unit_data_{i} = IntegralUnit(i);
            unit = this.integral_unit_data_{i};
            unit.integral_element_ = this.patch_data_.element_data_{i};
            element_node_id = unit.integral_element_.node_id_;
            element_type = unit.integral_element_.element_type_;
            unit.integral_element_node_ = this.patch_data_.point_data_{element_node_id};
            unit.gauss_quadrature_ = ...
                GaussQuadrature.MappingElementType2GaussQuadrature(element_type);
        end
    else
        disp('Error <FEM.IntegrationRule>! (Interior)');
        disp('> PatchType error!');
    end
        
end

