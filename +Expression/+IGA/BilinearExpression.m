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
            
            local_matrix = cell(num_q,1);
                        
%             % Bind query function
%             import Utility.BasicUtility.Region
%             if query_unit.int_region_ == Region.Domain
%                 query_function =@(query_unit) test_basis.query(query_unit);
%             elseif query_unit.int_region_ == Region.Boundary
%                 patch_name = [];
%                 this.var_.basis_data_.topology_data_;
%                 query_function =@(query_unit) test_basis.query(query_unit, patch_name);
%             end
            
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
                
                % get local mapping
                F = mapping.queryLocalMapping(query_unit);
                
                [dx_dxi, J] = F.calJacobian();
                
                dxi_dx = inv(dx_dxi);
                              
                % eval basis derivative with x
                B_test = dxi_dx * test_eval{2};
                B_var = dxi_dx * var_eval{2};
                
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

