classdef NitscheRhsExpression < Expression.IGA.Expression
    %BILINEAREXPRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        beta_ = [];
        source_function_;
    end
    
    methods
        function this = NitscheRhsExpression()
            this@Expression.IGA.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Vector;
            var = {this.test_};
            
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
                
                % eval basis derivative with x                             
                B_test = dx_dxi \ test_eval{2};
                
                % eval source function at quadrature point
                x = differential.mapping();
                
                val = this.source_function_(x(1), x(2));
                
                % eval normal vector at quadrature point
                normal = differential.normalVector();
                
                % add to local matrix
                local_matrix{i} = (-(normal*B_test)' + this.beta_* test_eval{1}')* val .* qw(i) * J; 
            end
            
            data = local_matrix{1};
            for i = 2 : num_q
                data = data + local_matrix{i};
            end
            
        end
        
        function setSourceFunction(this, f)
            this.source_function_ = f;
        end
        
        function setPenaltyParameter(this, beta)
            this.beta_ = beta;
        end
    end
    
end

