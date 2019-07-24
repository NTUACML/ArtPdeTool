classdef ElasticityTractionExpression < Expression.IGA.Expression
    %ElasticityBilinearExpression Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        traction_function_
    end
    
    methods
        function this = ElasticityTractionExpression()
            this@Expression.IGA.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Vector;
            var = {this.test_};
            
            % TODO:In bilinear form consisting of multiplication of derivatives
            % of shape & test, first order derivatives are necessary. Try
            % to improve this process, make it automatic.
            query_unit.query_protocol_{3} = 0;
            
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
                
                [~, J] = differential.jacobian();
                
                x = differential.mapping();
                                                              
                % eval linear form
                N_test = zeros(2, 2*length(test_non_zero_id));
                
                odd = 1:2:2*length(test_non_zero_id);
                even = 2:2:2*length(test_non_zero_id);
                
                N_test(1, odd) = test_eval{1};
                
                N_test(2, even) = test_eval{1};
                
                % add to local matrix
                [t_x, t_y] = this.traction_function_(x(1), x(2));
                local_matrix{i} = (N_test' * [t_x; t_y]).* qw(i) * J; 
            end
            
            data = local_matrix{1};
            for i = 2 : num_q
                data = data + local_matrix{i};
            end
        end
        
        function setTractionFunction(this, f)
            this.traction_function_ = f;
        end
    end
    
end

