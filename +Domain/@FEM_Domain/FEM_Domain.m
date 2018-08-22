classdef FEM_Domain < Domain.DomainBase
    %FEM_DOMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = FEM_Domain(variable, isoparametric_geometry)
            this@Domain.DomainBase(variable)
            % set isoparametric geometry
            this.setIsoparametricGeometry(isoparametric_geometry);
            % generate variable data
            this.generateVariableData();
            % generate interior domain (FEM method)
            this.generateInteriorDomain();
        end

    end
    
    % header define
    methods (Access = private)
        function setIsoparametricGeometry(this, isoparametric_geometry)
            this.setApproximatedGeometry(isoparametric_geometry);
            this.setIntegralGeometry(isoparametric_geometry);
        end
        
        function generateInteriorDomain(this)
            import Domain.InteriorDomain.FEM.*
            % create interior domain by the interior patch 
            % inside of the approximated geometry 
            this.interior_domain_ = ...
                InteriorDomain(this.approximated_geo_.interior_patch_data_);
            % add integration rule by the interior patch
            % inside of the integral geometry 
            this.interior_domain_.setIntergationRule(...
                this.integral_geo_.interior_patch_data_);
        end
    end
    
    % cpp define
    methods (Access = private)

    end
end

