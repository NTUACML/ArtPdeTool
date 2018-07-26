classdef PointFunctionSpaceClass < FunctionSpaceClass
    %MESHFUNCTIONSPACECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        point_non_zero_basis_  % Pre-defined(Point type): non_zero_basis
        point_evaluate_basis_  % Pre-defined(Point type): evaluate_basis
    end
    
    methods
        % constructor (Input: domain data)
        function this = PointFunctionSpaceClass(domain)
            % Call base class constructor
            this = this@FunctionSpaceClass(domain);
            disp('FunctionSpace <Point type> : created!');
        end
        
        % !!!(overried function)!!!
        % generate function information by domain data.
        function status = generate(this, varargin)
            % define and calculate point type function space.
            status = generatePointFunctionSpace( this, varargin );
        end
        
        % !!!(overried function)!!!
        % quarry basis information by quarry_unit
        % (Input: quarry_unit)
        % (Output: non_zero_basis[function handle], 
        %          evaluate_basis[function handle])
        function [non_zero_basis, evaluate_basis] = quarry(this, quarry_unit, varargin)
            non_zero_basis = @() this.point_non_zero_basis_(quarry_unit);
            evaluate_basis = @(id) this.point_evaluate_basis_(quarry_unit, id);
        end
    end
    
    methods (Access = private)
        status = generatePointFunctionSpace( this, varargin )
        shape_function = MappingMeshType2ShapeFunction( this, mesh_type )
    end
end

