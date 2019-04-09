classdef NitscheInterfaceExpression < Expression.IGA.Expression
    %BILINEAREXPRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        beta_ = [];
    end
    
    methods
        function this = NitscheInterfaceExpression()
            this@Expression.IGA.Expression();
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, mapping)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Coupled;           
            var = { {this.test_{1}; this.var_{1}}, {this.test_{1}; this.var_{2}}, ...
                {this.test_{2}; this.var_{1}}, {this.test_{2}; this.var_{2}} };
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
                               
            
%             test_basis = this.test_{1}.basis_data_;
%             var_basis = this.var_{1}.basis_data_;
%             test_basis_2 = this.test_{2}.basis_data_;
%             var_basis_2 = this.var_{2}.basis_data_;
            
            % The basis query protocal in IGA is point by point, while in
            % FEM is element by element. Hence we do not known the non-zero
            % basis befroe query. In other word, the size of local matrix
            % is not known in piror.
            local_matrix = cell(num_q,1);
            
            % loop integration points
            for i = 1 : num_q                
                [query_unit_m, query_unit_s] = this.generateInterfaceQueryUnit(qx(i,:), query_unit, mapping);
                
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
                
                normal = F.calNormalVector();
                
                dxi_dx = inv(dx_dxi);
                              
                % eval basis derivative with x
                B_var = dxi_dx * var_eval{2};
                                             
                % add to local matrix
                temp = (test_eval{1}' * normal * B_var);
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
    
    methods (Access = private)
        function [query_unit_m, query_unit_s] = this.generateInterfaceQueryUnit(this, s, query_unit, mapping)
            import BasisFunction.IGA.QueryUnit            
            query_unit_m = QueryUnit();
            query_unit_s = QueryUnit();
            
            query_unit_m.query_protocol = {query_unit.query_protocol{1}.master_patch_, s, 1};
            query_unit_s.query_protocol = {query_unit.query_protocol{1}.slave_patch_, [], 1};
            
            F_1 = mapping{1}.queryLocalMapping(query_unit);
            x = F_1.calPhysicalPosition();
            
        end
    end
    
end

