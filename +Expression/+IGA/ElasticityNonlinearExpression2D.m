classdef ElasticityNonlinearExpression2D < Expression.IGA.Expression 
    properties
        constitutive_law_
    end
    
    methods
        function this = ElasticityNonlinearExpression2D(constitutive_law)
            this@Expression.IGA.Expression();
            this.constitutive_law_ = constitutive_law;
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.System;
            var = {this.test_; this.var_};
            
            % TODO:In bilinear form consisting of multiplication of derivatives
            % of shape & test, first order derivatives are necessary. Try
            % to improve this process, make it automatic.
            query_unit.query_protocol_{3} = 1;
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            test_basis = this.test_.basis_data_;
            var_basis = this.var_.basis_data_;
            
            num_col = this.var_.num_dof_ * prod(var_basis.topology_data_.domain_patch_data_.nurbs_data_.order_+1);
            num_row = this.test_.variable_data_.num_dof_ * prod(test_basis.topology_data_.domain_patch_data_.nurbs_data_.order_+1);
            
            data = {zeros(num_row, num_col), zeros(num_row, 1)};
            
            % loop integration points
            for i = 1 : num_q
                query_unit.query_protocol_{2} = qx(i,:);
                
                % Test query
                % The same as variable query
                
                % Variable query
                var_basis.query(query_unit);
                non_zero_id = query_unit.non_zero_id_;

                % Put non_zero id
                basis_id = {non_zero_id, non_zero_id};
                
                % get local mapping
                differential.queryAt(qx(i,:));
                
                [dx_dxi, J] = differential.jacobian();
                
                % eval basis derivative w.r.t. x
                d_N_dx = dx_dxi \ query_unit.evaluate_basis_{2};
                
                % eval deformation gradient F
                [F, F_matrix] = this.deformationGradient(d_N_dx, non_zero_id);
                
                this.constitutive_law_.evaluate(F);
                Piola_stress = this.constitutive_law_.PiolaStress();
                D_matrix = this.constitutive_law_.materialMatrix();
                              
                % generate B-matrix
                B_G = zeros(4, 2*length(non_zero_id));
                
                col_1 = 1:2:2*length(non_zero_id);
                col_2 = 2:2:2*length(non_zero_id);
                
                for row_id = 1:2
                    B_G(row_id, col_1) = d_N_dx(row_id,:);
                    B_G(2+row_id, col_2) = d_N_dx(row_id,:);
                end
                               
                B_N = F_matrix * B_G;
                
                % generate S-matrix
                S = [Piola_stress(1) Piola_stress(3);
                     Piola_stress(3) Piola_stress(2)];
                
                Sigma = zeros(4,4);
                Sigma(1:2,1:2) = S;
                Sigma(3:4,3:4) = S;
                
                % add to local matrix
                data{1} = data{1} + (B_N'*D_matrix*B_N + B_G'*Sigma*B_G) * qw(i) * J;
                
                data{2} = data{2} - B_N'*Piola_stress * qw(i) * J; 
            end
            
        end
        
    end
    
    methods (Access = private)
        function [F, F_matrix] = deformationGradient(this, d_N_dx, non_zero_id)
            var = this.var_.getVarData();
            
            F = eye(2) + (d_N_dx*var(non_zero_id,:))';
            
            F_matrix = [F(1,1) 0      F(2,1) 0;
                        0      F(1,2) 0      F(2,2);
                        F(1,2) F(1,1) F(2,2) F(2,1)];
        end
    end
    
end

