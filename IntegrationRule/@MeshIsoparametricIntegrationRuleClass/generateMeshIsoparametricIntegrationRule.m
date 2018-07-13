function status = generateMeshIsoparametricIntegrationRule( this, varargin )
%GENERATEMESHISOPARAMETRICRULE Summary of this function goes here
%   Detailed explanation goes here

    this.num_int_unit_ = this.domain_data_.num_element_;
    this.int_unit_ = cell(this.num_int_unit_, 1);
    
    for i = 1 : this.num_int_unit_
        this.int_unit_{i} = this.MappingMeshType2GaussQuadrature(this.domain_data_.element_types_{i});
    end

    disp('IntegrationRule <Isoparamtric Mesh Type> :');
    disp('>> generated isoparamtric integrational data !')

    status = logical(true);
end

