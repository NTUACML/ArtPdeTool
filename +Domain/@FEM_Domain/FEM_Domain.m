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
            % generate interior domain
            this.generateInteriorDomain();
            
        end
        
%         function setApproximatedGeometry(this, approximated_geo, ...
%                                                 varargin)
%             setApproximatedGeometry@Domain.DomainBase(this, approximated_geo);
%             if(isempty(varargin))
%                 this.createFEM_FunctionSpace([])
%             else
%                 this.createFEM_FunctionSpace(varargin{1})
%             end
%         end
%         
%         function setIntegralGeometry(this, approximated_geo, ...
%                                                 varargin)
%             setIntegralGeometry@Domain.DomainBase(this, approximated_geo);
%             if(isempty(varargin))
%                 this.createFEM_IntegrationRule([])
%             else
%                 this.createFEM_IntegrationRule(varargin{1})
%             end
%         end
    end
    
    % header define
    methods (Access = private)
        function setIsoparametricGeometry(this, isoparametric_geometry)
            this.setApproximatedGeometry(isoparametric_geometry);
            this.setIntegralGeometry(isoparametric_geometry);
        end
        
        function generateInteriorDomain(this)
            import Domain.InteriorDomain.FEM.*
            this.num_interior_domain_ = 1;
            this.interior_domain_ = InteriorDomain();
        end
    end
    
    % cpp define
    methods (Access = private)
%         createFEM_FunctionSpace(this, var)
%         createFEM_IntegrationRule(this, var)
    end
end

