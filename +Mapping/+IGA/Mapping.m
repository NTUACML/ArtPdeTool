classdef Mapping < Mapping.MappingBase
    %MAPPING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        points_
    end
    
    methods
        function this = Mapping(basis)
            this@Mapping.MappingBase(basis);
            dim = this.basis_.topology_data_.dim_;
            this.points_ = this.basis_.topology_data_.point_data_(:,1:dim);
        end
        
        function mapping_unit = queryLocalMapping(this, query_unit)
            import Mapping.IGA.MappingUnit
            % In order to evaluate Jacobian, 1st order derivative is
            % required. However, in massexpression, the default query
            % protocol is to query the BASIS VALUE only. We have to
            % modify the protocol here. TODO, re-design a process for
            % query protocol.
            query_unit.query_protocol_{3} = 1;
            
            this.basis_.query(query_unit, []);            
            eval_basis = query_unit.evaluate_basis_;
            non_zero_id = query_unit.non_zero_id_;
            local_pt = this.points_(non_zero_id, :);
            mapping_unit = MappingUnit(local_pt, eval_basis, query_unit.query_protocol_{1});
        end
        
        function parametric_coordinate = inverseMapping(this, physical_coordinate, patch_data, varargin)                           
            import Utility.NurbsUtility.NurbsType
            switch patch_data.nurbs_data_.type_
                case NurbsType.Curve
                    % Newton iteration for solving parametric coordinate
                    % given x = f(s), for specific x, find s.
                    
                    % Initial guessing
                    if isempty(varargin)
                        eps = rand(1)*1e-5;
                        xi = 0.5*(max(patch_data.nurbs_data_.knot_vectors_{1}) + min(patch_data.nurbs_data_.knot_vectors_{1}));
                        
                        t_1 = xi-eps;
                        [~, ~, res_1] = this.eval(patch_data, t_1, physical_coordinate);
                        
                        t_2 = xi+eps;
                        [~, ~, res_2] = this.eval(patch_data, t_2, physical_coordinate);
                        
                        if (res_1 <= res_2)
                            parametric_coordinate = t_1;
                        else
                            parametric_coordinate = t_2;
                        end
                    else
                        parametric_coordinate = varargin{1};
                    end
     
                    iter_times = 15;
                    [parametric_coordinate, residual, cnt] = ...
                        this.NewtonIteration(patch_data, parametric_coordinate, physical_coordinate, iter_times);
                     
                    if cnt > iter_times
                        disp('Iteration failed with the current initial guess. Activate the re-initialization process.')
                        parametric_coordinate = this.reInitializedParametricCoordinate();
                        
                        [parametric_coordinate, residual, cnt] = ...
                            this.NewtonIteration(patch_data, parametric_coordinate, physical_coordinate, iter_times);
                    end
                    
                    str = ['cnt: ', num2str(cnt)];
                    disp(str);
                    str = ['residual: ', num2str(residual)];
                    disp(str);
                    str = ['parametric_coordinate: ', num2str(parametric_coordinate)];
                    disp(str);
                otherwise % Plane or Surface
                    % Newton iteration for solving parametric coordinate
                    % given x = f(s), for specific x, find s.
                    
                    % Initial guessing
                    if isempty(varargin)
                        eps = rand(1)*1e-1;
                        xi = 0.5*[patch_data.nurbs_data_.knot_vectors_{1}(1) +  patch_data.nurbs_data_.knot_vectors_{1}(end), ...
                            patch_data.nurbs_data_.knot_vectors_{2}(1) +  patch_data.nurbs_data_.knot_vectors_{2}(end)];
                        
                        xi_test{1} = xi+[eps 0];
                        [~, ~, res_1] = this.eval(patch_data, xi_test{1}, physical_coordinate);
                        
                        xi_test{2} = xi-[eps 0];
                        [~, ~, res_2] = this.eval(patch_data, xi_test{2}, physical_coordinate);
                        
                        xi_test{3} = xi+[0 eps];
                        [~, ~, res_3] = this.eval(patch_data, xi_test{3}, physical_coordinate);
                        
                        xi_test{4} = xi-[0 eps];
                        [~, ~, res_4] = this.eval(patch_data, xi_test{4}, physical_coordinate);
                        
                        
                        [~,I] = min([res_1 res_2 res_3 res_4]);
                        
                        parametric_coordinate = xi_test{I};
                        
                    else
                        parametric_coordinate = varargin{1};
                    end
                    
                    iter_times = 15;
                    [parametric_coordinate, residual, cnt] = ...
                        this.NewtonIteration(patch_data, parametric_coordinate, physical_coordinate, iter_times);
                     
                    if cnt > iter_times
                        disp('Iteration failed with the current initial guess. Need to activate the re-initialization process. Still under programming...')
                    end
                    
                    str = ['cnt: ', num2str(cnt)];
                    disp(str);
                    str = ['residual: ', num2str(residual)];
                    disp(str);
                    str = ['parametric_coordinate: ', num2str(parametric_coordinate)];
                    disp(str);
                    
            end
        
        end
   
    end
    
    methods (Access = private)
        function [dC_dt, F, residual] = eval(this, patch_data, parametric_coordinate, physical_coordinate)
            import BasisFunction.IGA.QueryUnit
            query_unit = QueryUnit();
            query_unit.query_protocol_ = {patch_data, parametric_coordinate, 1};
            
            mapping = this.queryLocalMapping(query_unit);
            C = mapping.calPhysicalPosition();
            dC_dt = mapping.calTangentVector();
            
            F = (C-physical_coordinate);
            residual = norm(F);            
        end
        
        function [parametric_coordinate, residual, cnt] = NewtonIteration(this, patch_data, parametric_coordinate, physical_coordinate, iter_times)
            [dC_dt, F, residual] = this.eval(patch_data, parametric_coordinate, physical_coordinate);
            
            cnt = 0;
            switch patch_data.dim_
                case 1
                    while residual > 1e-10 && cnt <= iter_times
%                         delta_t = - residual^2 / dot(F, dC_dt);
                        delta_t = - dot(F, dC_dt) / dot(dC_dt, dC_dt);
                        
                        parametric_coordinate = parametric_coordinate + delta_t;
                        
                        if parametric_coordinate < 0
                            parametric_coordinate = 0;
                        elseif parametric_coordinate > 1
                            parametric_coordinate = 1;
                        end
                        
                        [dC_dt, F, residual] = this.eval(patch_data, parametric_coordinate, physical_coordinate);
                        
                        cnt = cnt + 1;
                    end
                case 2
                    while residual > 1e-10 && cnt <= iter_times                                               
                        A = [dot(dC_dt(1,:), dC_dt(1,:)) dot(dC_dt(1,:), dC_dt(2,:)); ...
                                dot(dC_dt(1,:), dC_dt(2,:)) dot(dC_dt(2,:), dC_dt(2,:))];
                            
                        B = [dot(dC_dt(1,:), F); dot(dC_dt(2,:), F)];
                        
                        delta_t = -A\B;
                        
                        parametric_coordinate = parametric_coordinate + delta_t';
                        
                        bool = parametric_coordinate < 0;
                        parametric_coordinate(bool) = 0;
                        
                        bool = parametric_coordinate > 1;
                        parametric_coordinate(bool) = 1;
                                          
                        [dC_dt, F, residual] = this.eval(patch_data, parametric_coordinate, physical_coordinate);
                        
                        cnt = cnt + 1;
%                         str = [num2str(cnt), ' : ', num2str(residual) ];
%                         disp(str);
                    end
            end
                
            
           
        end
        
        function parametric_coordinate = reInitializedParametricCoordinate(this)
            parametric_coordinate = 0.5+eps;
            disp('Ask Kavy');
            % search nearist control point and use the corresponding parametric coordinate as inintial guess 

        end
    end
    
end

