classdef BilinearExpression < Expression.IGA.Expression
    %BILINEAREXPRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = BilinearExpression()
            this@Expression.IGA.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, mapping)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Matrix;
            var = {this.test_; this.var_};
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            test_basis = this.test_.basis_data_;
            var_basis = this.var_.basis_data_;
            
            local_matrix = cell(num_q,1);
            
            % loop integration points
            for i = 1 : num_q
                query_unit.query_protocol_{2} = num2cell(qx(i,:));
                
                % Test query
                test_basis.query(query_unit, []);
                test_non_zero_id = query_unit.non_zero_id_;
                test_eval = query_unit.evaluate_basis_;
                
                % Variable query
                var_basis.query(query_unit, []);
                var_non_zero_id = query_unit.non_zero_id_;
                var_eval = query_unit.evaluate_basis_;
                
                % Put non_zero id
                basis_id = {test_non_zero_id, var_non_zero_id};
                
                % get local mapping
                F = mapping.queryLocalMapping(query_unit);

                [dx_dxi, J] = F.calJacobian();
                % TODO This is NOT GOOD........ dx_dxi should be a square
                % matrix....
                dxi_dx = inv(dx_dxi(:,1:2));
                
                % eval basis derivative with x
                d_test_dx = dxi_dx * test_eval{2};
                d_var_dx = dxi_dx * var_eval{2};
                
                % eval bilinear form
                B_test = d_test_dx;
                B_var = d_var_dx;
                
                % add to local matrix
                local_matrix{i} = (B_test' * B_var).* qw(i) * J; 
            end
            
            data = local_matrix{1};
            for i = 2 : num_q
                data = data + local_matrix{i};
            end
        end

    end
    
end

