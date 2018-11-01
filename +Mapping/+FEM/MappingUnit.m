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
        
        function [dxi_dx, dx_dxi] = calJacobian(this, xi)
            [~, d_basis_dxi] = this.eval_basis_(xi);
            dx_dxi = d_basis_dxi * this.local_point_;
            dxi_dx = inv(dx_dxi);
        end
    end
    
end

