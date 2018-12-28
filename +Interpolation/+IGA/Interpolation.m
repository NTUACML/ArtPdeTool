classdef Interpolation < Interpolation.InterpolationBase
    %INTERPOLATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        interpo_topo_
    end
    
    methods
        function this = Interpolation(variable)
            this@Interpolation.InterpolationBase();
            if(isa(variable, 'Variable.Variable'))
                this.interpo_data_ = variable;
                this.interpo_basis_ = variable.basis_data_;
                this.interpo_topo_ = this.interpo_basis_.topology_data_;
            else
                disp('Error <Interpolation = FEM>! ');
                disp('> The input type should be a variable!');
            end
        end
        
        function [x, data, element] = DomainDataSampling(this, varargin)
            import Utility.Resources.*
            geoDim = this.interpo_topo_.dim_;
            
            if isempty(varargin)
                varargin{1} = 10*ones(1,geoDim);
            end
            
            % Generate parametric mesh
            switch geoDim
                case 2
                    mesh = mesh2d(varargin{1}(1)-1, varargin{1}(2)-1, 1, 1);
                case 3
                    mesh = mesh3d(varargin{1}(1)-1, varargin{1}(2)-1, varargin{1}(3)-1, 1, 1, 1);
            end
            
            element = mesh.connect;
            x = zeros(mesh.node_number, 3);
            data = zeros(mesh.node_number, 1);
            
            % Get computation information
            var_coef = this.interpo_data_.getVarData();
            
            patch = this.interpo_topo_.getDomainPatch();
            control_points = patch.nurbs_data_.control_points_(:,1:3);

            basis_function = this.interpo_basis_;
            
            % Create query unit
            import BasisFunction.IGA.QueryUnit
            import Utility.BasicUtility.Region
            query_unit = QueryUnit();
            query_unit.query_protocol_{1} = Region.Domain;
            
            % Evaluate physical position & variable
            for i = 1:mesh.node_number               
                query_unit.query_protocol_{2} = mesh.node(i,:);
                basis_function.query(query_unit);
                non_zero_id = query_unit.non_zero_id_;
                R = query_unit.evaluate_basis_{1};
                x(i,:) = R*control_points(non_zero_id,:);
                data(i) = R*var_coef(non_zero_id);
            end
        end
    end
    
end

