classdef MeshIsoparametricIntegrationRuleClass < MeshIntegrationRuleClass
    %MESHISOPARAMETRICINTEGRATIONRULECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        % constructor
        function this = MeshIsoparametricIntegrationRuleClass(domain)
            % Call base class constructor
            this = this@MeshIntegrationRuleClass();
            this.domain_data_ = domain;
            this.is_isoparamtric = logical(true);
            disp('IntegrationRule <Isoparamtric Mesh Type> : created!')
        end
        
        % !!!(overried function)!!!
        % generate integration rule data.
        function status = generate(this, varargin)
            status = this.generateMeshIsoparametricIntegrationRule(varargin);
        end
        
        function [int_unit, evaluate_jacobian] = quarry(this, quarry_unit, varargin)
            int_unit = this.int_unit_{quarry_unit};
            evaluate_jacobian = @(d_shape_func) MeshIntegrationRuleClass.evaluateJacobian(...
                d_shape_func, this.domain_data_.node_data_(this.domain_data_.connectivities_{quarry_unit}, :));
        end
    end
    
    methods (Access = private)
        status = generateMeshIsoparametricIntegrationRule( this, varargin )
        gauss_quadrature = MappingMeshType2GaussQuadrature( this, mesh_type )
    end
end

