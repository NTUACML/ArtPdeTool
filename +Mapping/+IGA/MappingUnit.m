classdef MappingUnit < handle
    %MAPPINGUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        local_point_
        eval_basis_
        patch_
    end
    
    methods
        function this = MappingUnit(local_point, eval_basis, patch)
            this.local_point_ = local_point;
            this.eval_basis_ = eval_basis;
            this.patch_ = patch;
        end
        
        function [dx_dxi, J] = calJacobian(this)          
            import Utility.BasicUtility.Region
            if this.patch_.region_ == Region.Boundary
                [dx_dxi, tangent_vector] = this.calTangentVector();
                
                if size(tangent_vector,1) == 1 
                    J = norm(tangent_vector);
                else
                    J = norm(cross(tangent_vector(1,:), tangent_vector(2,:)));                   
                end
            elseif this.patch_.region_ == Region.Domain
                dx_dxi = this.eval_basis_{2} * this.local_point_;
                % dx_dxi = [dx/dxi dy/dxi; dx/deta dy/deta] in 2D
                % dx_dxi = [dx/dxi dy/dxi dz/dxi; dx/deta dy/deta dz/deta; dx/dzeta dy/dzeta dz/dzeta] in 3D
                J = det(dx_dxi);
            end
            
        end
        
        function x = calPhysicalPosition(this)
            x = this.eval_basis_{1} * this.local_point_;
        end
                
        function normal_vector = calNormalVector(this)
            dx_dxi = this.eval_basis_{2} * this.local_point_;
            
            switch this.patch_.dim_
                case 1
                    if any(strcmp(this.patch_.name_, {'eta_0', 'eta_1'}))
                        dxi_ds = [1 0];
                    else
                        dxi_ds = [0 1];
                    end
                    
                    tangent_vector = dxi_ds * dx_dxi;
                    
                    if this.patch_.nurbs_data_.orientation_ == 1
                        normal_vector = tangent_vector*[0 -1; 1 0];
                    else
                        normal_vector = tangent_vector*[0 1; -1 0];
                    end                    
                case 2
                    if any(strcmp(this.patch_.name_, {'xi_0', 'xi_1'}))
                        dxi_ds = [0 1 0; 0 0 1];
                    elseif any(strcmp(this.patch_.name_, {'eta_0', 'eta_1'}))
                        dxi_ds = [0 0 1; 1 0 0];
                    else
                        dxi_ds = [1 0 0; 0 1 0];
                    end
                    
                    tangent_vector = dxi_ds * dx_dxi;
                    
                    if this.patch_.nurbs_data_.orientation_ == 1
                        normal_vector = cross(tangent_vector(1,:), tangent_vector(2,:));
                    else
                        normal_vector = -cross(tangent_vector(1,:), tangent_vector(2,:));
                    end  
                    
            end
            
            normal_vector = normal_vector/ norm(normal_vector);
                        
        end
        
    end
    
    methods (Access = private)
        function [dx_dxi, tangent_vector] = calTangentVector(this)
            dx_dxi = this.eval_basis_{2} * this.local_point_;
            
            switch this.patch_.dim_
                case 1
                    if any(strcmp(this.patch_.name_, {'eta_0', 'eta_1'}))
                        dxi_ds = [1 0];
                    else
                        dxi_ds = [0 1];
                    end
                case 2
                    if any(strcmp(this.patch_.name_, {'xi_0', 'xi_1'}))
                        dxi_ds = [0 1 0; 0 0 1];
                    elseif any(strcmp(this.patch_.name_, {'eta_0', 'eta_1'}))
                        dxi_ds = [0 0 1; 1 0 0];
                    else
                        dxi_ds = [1 0 0; 0 1 0];
                    end
             end
                        
            tangent_vector = dxi_ds * dx_dxi;
        end
        
    end
end

