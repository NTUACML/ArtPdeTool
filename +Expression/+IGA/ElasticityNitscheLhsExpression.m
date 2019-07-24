classdef ElasticityNitscheLhsExpression < Expression.IGA.Expression
    %ElasticityBilinearExpression Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        beta_ = []
        constitutive_law_
    end
    
    methods
        function this = ElasticityNitscheLhsExpression(constitutive_law)
            this@Expression.IGA.Expression();
            this.constitutive_law_ = constitutive_law;
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Matrix;
            var = {this.test_; this.var_};
            
            % TODO:In bilinear form consisting of multiplication of derivatives
            % of shape & test, first order derivatives are necessary. Try
            % to improve this process, make it automatic.
            query_unit.query_protocol_{3} = 1;
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            basis = this.test_.basis_data_;
            
            local_matrix = cell(num_q,1);
            
            this.constitutive_law_.evaluate(eye(2));
            D_matrix = this.constitutive_law_.materialMatrix();
            % loop integration points
            for i = 1 : num_q
                query_unit.query_protocol_{2} = qx(i,:);
                
                % Test query
                basis.query(query_unit, []);
                non_zero_id = query_unit.non_zero_id_;
                val_eval = query_unit.evaluate_basis_;
                
                % Put non_zero id
                basis_id = {non_zero_id, non_zero_id};
                
                % get local mapping
                differential.queryAt(qx(i,:));

                [dx_dxi, J] = differential.jacobian();
                                              
                % eval basis derivative with x
                d_N_dx = dx_dxi \ val_eval{2};
                
                % eval
                odd = 1:2:2*length(non_zero_id);
                even = 2:2:2*length(non_zero_id);
                
                B_matrix = zeros(3, 2*length(non_zero_id));
                                
                B_matrix(1, odd) = d_N_dx(1,:);
                B_matrix(2, even) = d_N_dx(2,:);
                
                B_matrix(3, odd) = d_N_dx(2,:);
                B_matrix(3, even) = d_N_dx(1,:);
                     
                N_matrix = zeros(2, 2*length(non_zero_id));
                
                N_matrix(1, odd) = val_eval{1};               
                N_matrix(2, even) = val_eval{1};
                
                % normal vector
                normal = differential.normalVector();
                normal_matrix = [normal(1) 0; 0 normal(2); normal];
                                
                temp = N_matrix' * normal_matrix' * D_matrix * B_matrix;
                % add to local matrix
                local_matrix{i} = (-temp - temp' + this.beta_* (N_matrix') * N_matrix).* qw(i) * J; 
            end
            
            data = local_matrix{1};
            for i = 2 : num_q
                data = data + local_matrix{i};
            end
        end
        
        function setPenaltyParameter(this, beta)
            this.beta_ = beta;
        end

    end
    
end

