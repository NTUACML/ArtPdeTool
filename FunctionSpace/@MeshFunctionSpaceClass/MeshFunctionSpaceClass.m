classdef MeshFunctionSpaceClass < FunctionSpaceClass
    %MESHFUNCTIONSPACECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mesh_non_zero_basis_  % Pre-defined(Mesh type): non_zero_basis
        mesh_evaluate_basis_  % Pre-defined(Mesh type): evaluate_basis
    end
    
    methods
        % constructor (Input: domain data)
        function this = MeshFunctionSpaceClass(domain)
            % Call base class constructor
            this = this@FunctionSpaceClass(domain);
            disp('FunctionSpace<Mesh type> : created!');
        end
        
        % !!!(overried function)!!!
        % generate function information by domain data.
        function status = generate(this, varargin)
            % define and calculate mesh type function space.
            status = generateMeshFunctionSpace( this, varargin );
        end
        
        % !!!(overried function)!!!
        % quarry basis information by quarry_unit
        % (Input: quarry_unit)
        % (Output: non_zero_basis[function handle], 
        %          evaluate_basis[function handle])
        function [non_zero_basis, evaluate_basis] = quarry(this, quarry_unit, varargin)
            non_zero_basis = this.mesh_non_zero_basis_{quarry_unit};
            evaluate_basis = this.mesh_evaluate_basis_{quarry_unit};
        end
    end
    
    methods (Access = private)
        status = generateMeshFunctionSpace( this, varargin )
        shape_function = MappingMeshType2ShapeFunction( this, mesh_type )
    end
end

