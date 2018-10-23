classdef NurbsBasisFunction
    %NURBSBASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        [ GlobalDof, R, dR_dxi ] = Nurbs_ShapeFunc( xi, p, knots, omega )
        span = FindSpan(n, p, u, U)
        [i,ders] = DersBasisFuns(u, p, U, varargin)
    end
    
end

