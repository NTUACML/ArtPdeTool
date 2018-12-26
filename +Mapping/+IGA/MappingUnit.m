classdef MappingUnit < handle
    %MAPPINGUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        local_point_
        eval_basis_
    end
    
    methods
        function this = MappingUnit(local_point, eval_basis)
            this.local_point_ = local_point;
            this.eval_basis_ = eval_basis;
        end
        
        function [dx_dxi, J] = calJacobian(this)
            dx_dxi = this.eval_basis_{2} * this.local_point_;
            % dx_dxi = [dx/dxi dy/dxi; dx/deta dy/deta] in 2D
            % dx_dxi = [dx/dxi dy/dxi dz/dxi; dx/deta dy/deta dz/deta; dx/dzeta dy/dzeta dz/dzeta] in 3D
            J = det(dx_dxi);
        end
        
        % For surface in 3d space, one have to use the following formula to compute the Jacobian
        function [dx_dxi, J] = calSurfaceJacobian(this)
            dx_dxi = this.eval_basis_{2} * this.local_point_;
            % dx_dxi = [dx/dxi dy/dxi; dx/deta dy/deta] in 2D
            % dx_dxi = [dx/dxi dy/dxi dz/dxi; dx/deta dy/deta dz/deta] in 3D           
            J = norm(cross(dx_dxi(1,:),dx_dxi(2,:)));  
        end
        
        function x = calPhysicalPosition(this)
            x = this.eval_basis_{1} * this.local_point_;
        end
    end
    
end

