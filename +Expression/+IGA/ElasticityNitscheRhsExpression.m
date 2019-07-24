classdef ElasticityLinearExpression < Expression.IGA.Expression
    %ElasticityBilinearExpression Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        source_function_
    end
    
    methods
        function this = ElasticityLinearExpression()
            this@Expression.IGA.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Vector;
            var = {this.test_};
            
            % TODO:In bilinear form consisting of multiplication of derivatives
            % of shape & test, first order derivatives are necessary. Try
            % to improve this process, make it automatic.
            query_unit.query_protocol_{3} = 1;
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            test_basis = this.test_.basis_data_;
            
            local_matrix = cell(num_q,1);
            
            % loop integration points
            for i = 1 : num_q
                query_unit.query_protocol_{2} = qx(i,:);
                
                % Test query
                test_basis.query(query_unit, []);
                test_non_zero_id = query_unit.non_zero_id_;
                test_eval = query_unit.evaluate_basis_;
                             
                % Put non_zero id
                basis_id = {test_non_zero_id};
                
                % get local mapping
                differential.queryAt(qx(i,:));

                [dx_dxi, J] = differential.jacobian();
                
                x = differential.mapping();
                                              
                % eval basis derivative with x
                d_test_dx = dx_dxi \ test_eval{2};
                
                % eval linear form
                D_test = zeros(1, 2*length(test_non_zero_id));
                
                odd = 1:2:2*length(test_non_zero_id);
                even = 2:2:2*length(test_non_zero_id);
                
                D_test(1, odd) = d_test_dx(1,:);
                
                D_test(1, even) = d_test_dx(2,:);
                
                % add to local matrix
                local_matrix{i} = (D_test' * this.source_function_(x(1), x(2))).* qw(i) * J; 
            end
            
            data = local_matrix{1};
            for i = 2 : num_q
                data = data + local_matrix{i};
            end
        end
        
        function setSourceFunction(this, f)
            this.source_function_ = f;
        end
    end
    
end

