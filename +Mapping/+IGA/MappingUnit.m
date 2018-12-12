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
        % TODO The mapping for 3d surface is special. In general, we cannot obtain the jacobian by direct inverse dx/dxi!
        % 11/6 Jeting
        function [dx_dxi, J] = calJacobian(this)
            dx_dxi = this.eval_basis_{2} * this.local_point_(:,1:end-1);
            % TODO currently for 3d surface 1106 Jeting
            J = norm(cross(dx_dxi(1,:),dx_dxi(2,:)));
            
        end
        
        function x = calPhysicalPosition(this)
            x = this.eval_basis_{1} * this.local_point_(:,1:end-1);
        end
    end
    
end

