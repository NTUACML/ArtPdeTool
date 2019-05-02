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
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Coupled;           
            var = { this.test_{1}, this.test_{2}, this.var_{1}, this.var_{2} };
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            % Get test & trial basis functions for master & slave patches
            basis_1 = this.var_{1}.basis_data_;
            basis_2 = this.var_{2}.basis_data_;
            
            num_non_zeros_1 = prod(basis_1.topology_data_.domain_patch_data_.nurbs_data_.order_+1);
            num_non_zeros_2 = prod(basis_2.topology_data_.domain_patch_data_.nurbs_data_.order_+1);
            
            local_matrix_11 = zeros(num_non_zeros_1, num_non_zeros_1); % test_m x var_m
            local_matrix_12 = zeros(num_non_zeros_1, num_non_zeros_2); % test_m x var_s
            local_matrix_21 = zeros(num_non_zeros_2, num_non_zeros_1); % test_s x var_m
            local_matrix_22 = zeros(num_non_zeros_2, num_non_zeros_2); % test_s x var_s
            
            % loop integration points
            for i = 1 : num_q                
                [query_unit_m, query_unit_s] = this.generateInterfaceQueryUnit(qx(i,:), query_unit, differential);

                % Query basis function & non_zero_id
                basis_1.query(query_unit_m);
                eval_m = query_unit_m.evaluate_basis_;
                
                basis_2.query(query_unit_s);
                eval_s = query_unit_s.evaluate_basis_;
                               
                % Put non_zero id
                basis_id = {query_unit_m.non_zero_id_, query_unit_s.non_zero_id_, query_unit_m.non_zero_id_, query_unit_s.non_zero_id_};
             
                % get local mapping for master patch
                differential.differential_m_.queryAt(query_unit_m.query_protocol_{2});
                [dx_dxi, J] = differential.differential_m_.jacobian();
                                                              
                % eval basis derivative with x
                B_m = dx_dxi \ eval_m{2};
                
                % get local mapping for slave patch  
                differential.differential_s_.queryAt(query_unit_s.query_protocol_{2});
                [dx_dxi, ~] = differential.differential_s_.jacobian();
                                              
                % eval basis derivative with x
                B_s = dx_dxi \ eval_s{2};
                
                % eval normal vector from master to slave
                normal = differential.differential_m_.normalVector();
                               
                tempA = 0.5 * normal * B_m;
                tempB = 0.5 * normal * B_s;
                % add to local matrix
                local_matrix_11 = local_matrix_11 + (-eval_m{1}'*tempA - tempA'*eval_m{1} + this.beta_ * eval_m{1}' * eval_m{1})* qw(i) * J; 
                
                local_matrix_12 = local_matrix_12 + (-eval_m{1}'*tempB + tempA'*eval_s{1} - this.beta_ * eval_m{1}' * eval_s{1})* qw(i) * J;
                
                local_matrix_21 = local_matrix_21 + (+eval_s{1}'*tempA - tempB'*eval_m{1} - this.beta_ * eval_s{1}' * eval_m{1})* qw(i) * J;
                
                local_matrix_22 = local_matrix_22 + (+eval_s{1}'*tempB + tempB'*eval_s{1} + this.beta_ * eval_s{1}' * eval_s{1})* qw(i) * J;
            end
            
            data = {local_matrix_11, local_matrix_12, local_matrix_21, local_matrix_22};
        end
        
        function setPenaltyParameter(this, beta)
            this.beta_ = beta;
        end
    end
    
    methods (Access = private)
        function [query_unit_m, query_unit_s] = generateInterfaceQueryUnit(this, s, query_unit, differential)                            
            % evaluate physical point 
            differential.differential_m_.queryAt(s);
            
            x = differential.differential_m_.mapping();
            t = differential.differential_s_.inverseMapping(x);
            
            import BasisFunction.IGA.QueryUnit            
            query_unit_m = QueryUnit();
            query_unit_s = QueryUnit();
            
            query_unit_m.query_protocol_ = {query_unit.query_protocol_{1}.master_patch_, s, 1};            
            query_unit_s.query_protocol_ = {query_unit.query_protocol_{1}.slave_patch_, t, 1};
        end
    end
    
end

