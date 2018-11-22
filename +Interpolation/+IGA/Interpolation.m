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
        
        function [x, data, element] = DomainDataSampling(this)
            % Generate parametric mesh
            import Utility.Resources.mesh2d
            mesh = mesh2d(10, 10, 1, 1);
            
            element = mesh.connect;
            x = zeros(size(mesh.xI));
            data = zeros(mesh.nn, 1);
            
            % Get computation information
            var_coef = this.interpo_data_.getVarData();
            
            patch = this.interpo_topo_.getDomainPatch();
            control_points = patch.nurbs_data_.control_points_(:,1:2);

            basis_function = this.interpo_basis_;
            
            % Create query unit
            import BasisFunction.IGA.QueryUnit
            import Utility.BasicUtility.Region
            query_unit = QueryUnit();
            
            % Evaluate physical position & variable
            for i = 1:mesh.nn
                xi = {mesh.xI(i,1) mesh.xI(i,2)};
                query_unit.query_protocol_ = {Region.Domain, xi};
                basis_function.query(query_unit);
                non_zero_id = query_unit.non_zero_id_;
                R = query_unit.evaluate_basis_{1};
                x(i,:) = R*control_points(non_zero_id,:);
                data(i) = R*var_coef(non_zero_id);
            end
        end
    end
    
end

