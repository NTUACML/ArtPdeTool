classdef NitscheLhsExpression < Expression.IGA.Expression
    %BILINEAREXPRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        beta_ = [];
    end
    
    methods
        function this = NitscheLhsExpression()
            this@Expression.IGA.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, mapping)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Matrix;
            var = {this.test_; this.var_};
            
            query_unit.query_protocol_{3} = 1;
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            test_basis = this.test_.basis_data_;
            var_basis = this.var_.basis_data_;
                        
            % The basis query protocal in IGA is point by point, while in
            % FEM is element by element. Hence we do not known the non-zero
            % basis befroe query. In other word, the size of local matrix
            % is not known in piror.
            local_matrix = cell(num_q,1);
            
            % loop integration points
            for i = 1 : num_q
                query_unit.query_protocol_{2} = qx(i,:);
                
                % Test query
                test_basis.query(query_unit);
                test_non_zero_id = query_unit.non_zero_id_;
                test_eval = query_unit.evaluate_basis_;
                
                % Variable query
                var_basis.query(query_unit);
                var_non_zero_id = query_unit.non_zero_id_;
                var_eval = query_unit.evaluate_basis_;
                
                % Put non_zero id
                basis_id = {test_non_zero_id, var_non_zero_id};
                
                
                % calculate normal vector at quadrature points
                
                
                % get local mapping
                F = mapping.queryLocalMapping(query_unit);

                [dx_dxi, J] = F.calJacobian();
                
                dxi_dx = inv(dx_dxi);
                              
                % eval basis derivative with x
                B_var = dxi_dx * var_eval{2};
                                             
                % add to local matrix
                temp = (test_eval{1}' *[n_1 n_2]* B_var);
                local_matrix{i} = (-temp - temp' + this.beta_ * test_eval{1}' * var_eval{1}).* qw(i) * J; 
                
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

