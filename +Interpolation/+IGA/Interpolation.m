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
                disp('Error <Interpolation = IGA>! ');
                disp('> The input type should be a variable!');
            end
        end
        
        function [x, data, element] = DomainDataSampling(this, varargin)
            import Utility.Resources.*
            geoDim = this.interpo_topo_.dim_;
            
            if isempty(varargin)
                node_num = 11*ones(1,geoDim);
                out_style = 'value'; 
                % default option. if 'gradient' is assigned, evaluate both
                % value & gradient
            else                
                node_num = varargin{1}.*ones(1,geoDim);
                out_style = varargin{2};
            end
            
            % Generate parametric mesh
            switch geoDim
                case 2
                    mesh = mesh2d(node_num(1)-1, node_num(2)-1, 1, 1);
                case 3
                    mesh = mesh3d(node_num(1)-1, node_num(2)-1, node_num(3)-1, 1, 1, 1);
            end
            
            element = mesh.connect;
            x = zeros(mesh.node_number, 3);
            
            data.value = cell(1,this.interpo_data_.num_dof_);
            for i = 1:this.interpo_data_.num_dof_
                data.value{i} = zeros(mesh.node_number, 1);
            end
            
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
            switch out_style                
                case 'value'
                    for i = 1:mesh.node_number
                        query_unit.query_protocol_{2} = mesh.node(i,:);
                        basis_function.query(query_unit);
                        non_zero_id = query_unit.non_zero_id_;
                        R = query_unit.evaluate_basis_{1};
                        x(i,:) = R*control_points(non_zero_id,:);
                        for k = 1:this.interpo_data_.num_dof_
                            data.value{k}(i) = R*var_coef(non_zero_id,k);
                        end
                    end
                case 'gradient'
                    data.gradient = cell(this.interpo_data_.num_dof_, this.interpo_data_.num_dof_);
                    for k = 1:this.interpo_data_.num_dof_
                        for j = 1:this.interpo_data_.num_dof_
                            data.gradient{k, j} = zeros(mesh.node_number, 1);
                        end
                    end
                    
                    query_unit.query_protocol_{3} = 1;
                    
                    for i = 1:mesh.node_number
                        query_unit.query_protocol_{2} = mesh.node(i,:);
                        basis_function.query(query_unit);
                        non_zero_id = query_unit.non_zero_id_;
                        R = query_unit.evaluate_basis_{1};
                        gradR = query_unit.evaluate_basis_{2};
                        
                        x(i,:) = R*control_points(non_zero_id,:);
                        for k = 1:this.interpo_data_.num_dof_
                            data.value{k}(i) = R*var_coef(non_zero_id,k);
                        end
                        
                        dx_dxi = [gradR(1,:)*control_points(non_zero_id,1:this.interpo_data_.num_dof_);
                            gradR(2,:)*control_points(non_zero_id,1:this.interpo_data_.num_dof_)];
                        
                        dxi_dx = inv(dx_dxi);
                        gradR = dxi_dx*gradR;
                        
                        for k = 1:this.interpo_data_.num_dof_
                            for j = 1:this.interpo_data_.num_dof_
                                data.gradient{k, j}(i) = gradR(j, :)*var_coef(non_zero_id,k);
                            end
                        end
                    end
            end
            
            

            
        end 
    end % end method
end % end class def    
    
    
