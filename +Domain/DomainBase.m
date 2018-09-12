classdef DomainBase < handle
    %DOMAINBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_id_ = 0
        variable_
        approximated_geo_
        integral_geo_
        interior_domain_
        num_boundary_domain_ = 0
        boundary_domain_
    end
    
    methods
        function this = DomainBase(variable)
            this.variable_ = variable;
        end
        
        function setApproximatedGeometry(this, approximated_geo)
            if(isa(approximated_geo, 'Geometry.Geometry'))
                this.approximated_geo_ = approximated_geo;
            else
                disp('Error <DomainBase>! check approximated geometry input type!');
                disp('> empty approximated geometry builded!');
            end
        end
        
        function setIntegralGeometry(this, integral_geo)
            if(isa(integral_geo, 'Geometry.Geometry'))
                this.integral_geo_ = integral_geo;
            else
                disp('Error <DomainBase>! check integral geometry input type!');
                disp('> empty integral geometry builded!');
            end
        end
        
        function setBoundaryCondition(this, imposed_bc)
            if(isa(imposed_bc, 'BoundaryCondition.BoundaryCondition'))
                this.num_boundary_domain_ = this.num_boundary_domain_ + 1;
                if(this.num_boundary_domain_ == 1)
                    this.boundary_domain_ = cell(this.num_boundary_domain_, 1);
                else
                    tmp = this.boundary_domain_;
                    this.boundary_domain_ = cell(this.num_boundary_domain_, 1);
                    for i = 1 : this.num_boundary_domain_ - 1
                        this.boundary_domain_{i} = tmp{i};
                    end
                end
            else
                disp('Error <DomainBase> - setBoundaryCondition!');
                disp('> the imposed bc type should be created by BoundaryCondition class!');
            end
        end
    end
    
    methods (Access = protected)
        function generateVariableData(this)
            if(~isempty(this.approximated_geo_))
                num_dof = this.variable_.num_dof_;
                num_data = this.approximated_geo_.num_point_;
                % set variable data number
                this.variable_.num_data_ = num_data;
                % set temporary data
                tmp_data = zeros(num_data, 1);
                % set data into variable
                for i = 1 : num_dof
                    this.variable_.dof_data_{i} = tmp_data;
                end
            else
                disp('Error <DomainBase>!');
                disp('> check approximated geometry setted up properly!');
            end
        end
        
        function bc_patch_id = searchApproximatedBoundaryPatchByName(this, name)
            bc_patch_id = 0;
            for i = 1 : this.approximated_geo_.num_boundary_patch_
                if(strcmp(this.approximated_geo_.boundary_patch_data_{i}.patch_name_, name))
                    bc_patch_id = i;
                end
            end
        end
        
        function bc_patch_id = searchIntegralBoundaryPatchByName(this, name)
            bc_patch_id = 0;
            for i = 1 : this.integral_geo_.num_boundary_patch_
                if(strcmp(this.integral_geo_.boundary_patch_data_{i}.patch_name_, name))
                    bc_patch_id = i;
                end
            end
        end
            
            
        
    end
    
end

