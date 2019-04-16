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
            var = { this.test_{1}, this.test_{2}, this.var_{1}, this.var_{2} };
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            % Get test & trial basis functions for master & slave patches
            basis_m = this.test_{1}.basis_data_;
            basis_s = this.test_{2}.basis_data_;
            
            number_m = prod(basis_m.topology_data_.domain_patch_data_.nurbs_data_.order_+1);
            number_s = prod(basis_s.topology_data_.domain_patch_data_.nurbs_data_.order_+1);
            
            local_matrix_mm = zeros(number_m, number_m); % test_m x var_m
            local_matrix_ms = zeros(number_m, number_s); % test_m x var_s
            local_matrix_sm = zeros(number_s, number_m); % test_s x var_m
            local_matrix_ss = zeros(number_s, number_s); % test_s x var_s
            
            % loop integration points
            for i = 1 : num_q                
                [query_unit_m, query_unit_s] = this.generateInterfaceQueryUnit(qx(i,:), query_unit, mapping);
                
                % Query basis function & non_zero_id
                basis_m.query(query_unit_m);
                eval_m = query_unit_m.evaluate_basis_;
                
                basis_s.query(query_unit_s);
                eval_s = query_unit_s.evaluate_basis_;
                               
                % Put non_zero id
                basis_id = {query_unit_m.non_zero_id_, query_unit_s.non_zero_id_, query_unit_m.non_zero_id_, query_unit_s.non_zero_id_};
             
                % get local mapping for master patch
                F_m = mapping{1}.queryLocalMapping(query_unit_m);

                [dx_dxi, J] = F_m.calJacobian();
                                                              
                % eval basis derivative with x
                B_m = dx_dxi \ eval_m{2};
                
                % get local mapping for slave patch                           
                F_s = mapping{2}.queryLocalMapping(query_unit_s);

                [dx_dxi, ~] = F_s.calJacobian();
                                              
                % eval basis derivative with x
                B_s = dx_dxi \ eval_s{2};
                
                % eval normal vector from master to slave
                normal = F_m.calNormalVector();
                
                % add to local matrix
                temp = (eval_m{1}' * normal * B_m);
                local_matrix_mm = local_matrix_mm + (-temp - temp' + this.beta_ * eval_m{1}' * eval_m{1}).* qw(i) * J; 
                
                temp = (eval_m{1}' * normal * B_s);
                local_matrix_ms = local_matrix_ms + (-temp - temp' + this.beta_ * eval_m{1}' * eval_s{1}).* qw(i) * J;
                
                temp = (eval_s{1}' * normal * B_m);
                local_matrix_sm = local_matrix_sm + (-temp - temp' + this.beta_ * eval_s{1}' * eval_m{1}).* qw(i) * J;
                
                temp = (eval_s{1}' * normal * B_s);
                local_matrix_ss = local_matrix_ss + (-temp - temp' + this.beta_ * eval_s{1}' * eval_s{1}).* qw(i) * J;
            end
            
            data = {local_matrix_mm, local_matrix_ms, local_matrix_sm, local_matrix_ss};
        end
        
        function setPenaltyParameter(this, beta)
            this.beta_ = beta;
        end
    end
    
    methods (Access = private)
        function [query_unit_m, query_unit_s] = generateInterfaceQueryUnit(this, s, query_unit, mapping)
            import BasisFunction.IGA.QueryUnit            
            query_unit_m = QueryUnit();
            query_unit_s = QueryUnit();
                  
            query_unit_m.query_protocol_ = {query_unit.query_protocol_{1}.master_patch_, s, 1};
            
            % evaluate physical point 
            F_m = mapping{1}.queryLocalMapping(query_unit_m);
            x = F_m.calPhysicalPosition();
  
            t = mapping{2}.inverseMapping(x, query_unit.query_protocol_{1}.slave_patch_);
            
            query_unit_s.query_protocol_ = {query_unit.query_protocol_{1}.slave_patch_, t, 1};    
        end
    end
    
end

