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
        
        function setBoundaryCondition(this, imposed_bc, varargin)
            import Domain.BoundaryDomain.FEM.BoundaryDomain
            setBoundaryCondition@Domain.DomainBase(this, imposed_bc);
            % search approximated and integral domain id
            bc_approched_patch_id = this.searchApproximatedBoundaryPatchByName(imposed_bc.bc_patch_name_);
            bc_integral_patch_id = this.searchIntegralBoundaryPatchByName(imposed_bc.bc_patch_name_);
            if(bc_approched_patch_id == 0 || bc_integral_patch_id == 0)
                disp('Error <FEM_Domain> - setBoundaryCondition!');
                disp('> the boundary patch not found, check patch name again, please!');
                return;
            end
            % create new boundary domain
            bc_approched_patch = this.approximated_geo_.boundary_patch_data_{bc_approched_patch_id};
            this.boundary_domain_{this.num_boundary_domain_} = BoundaryDomain(bc_approched_patch);
            % set integration rule
            bc_integral_patch = this.integral_geo_.boundary_patch_data_{bc_integral_patch_id};
            this.boundary_domain_{this.num_boundary_domain_}.setIntergationRule(bc_integral_patch);
        end
    end
    
    % header define
    methods (Access = private)
        function setIsoparametricGeometry(this, isoparametric_geometry)
            this.setApproximatedGeometry(isoparametric_geometry);
            this.setIntegralGeometry(isoparametric_geometry);
        end
        
        function generateInteriorDomain(this)
            import Domain.InteriorDomain.FEM.InteriorDomain
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

