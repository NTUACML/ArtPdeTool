classdef BilinearExpression < Expression.FEM.Expression
    %BILINEAREXPRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = BilinearExpression()
            this@Expression.FEM.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit)
            import Utility.BasicUtility.VariableType
            type = VariableType.Matrix;
            var = {this.test_; this.var_};
            % Get quadrature
            [num_q, qx, qw] = query_unit.quadrature_();
            
            % Test query
            test_basis = this.test_.basis_data_;
            test_basis.query(query_unit, []);
            test_non_zero_id = query_unit.non_zero_id_;
            test_eval = query_unit.evaluate_basis_;
            
            % Variable query
            var_basis = this.var_.basis_data_;
            var_basis.query(query_unit, []);
            var_non_zero_id = query_unit.non_zero_id_;
            var_eval = query_unit.evaluate_basis_;
            
            % Put non_zero id
            basis_id = {test_non_zero_id, var_non_zero_id};
            
            % Cal Jacobin
            %... Todo...
            
            % Local integration
            data = zeros(length(test_non_zero_id), ...
                   length(var_non_zero_id));
               
            for i_q = 1 : num_q
                i_qx = qx(i_q, :);
                i_qw = qw(i_q);
                B_test = test_eval(i_qx);
                B_var = var_eval(i_qx);
                data = data + (B_test' * B_var).* i_qw; %*J
            end
        end

    end
    
end

