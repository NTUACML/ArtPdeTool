classdef Differential < Differential.DifferentialBase

    properties (Access = private)     
        points_
        mapping_unit_
    end
    
    methods
        function this = Differential(basis, patch)
            this@Differential.DifferentialBase(basis, patch);
            dim = this.basis_.topology_data_.dim_;
            this.points_ = this.basis_.topology_data_.point_data_(:,1:dim);
            this.mapping_unit_ = [];
        end
        
        function queryAt(this, xi)
            import BasisFunction.IGA.QueryUnit
            query_unit = QueryUnit();
            query_unit.query_protocol_ = {this.patch_, xi, 1};
            
            this.basis_.query(query_unit, []);            
            eval_basis = query_unit.evaluate_basis_;
            non_zero_id = query_unit.non_zero_id_;
            local_pt = this.points_(non_zero_id, :);
            
            import Mapping.IGA.MappingUnit
            this.mapping_unit_ = MappingUnit(local_pt, eval_basis, this.patch_);
        end
               
        function [dx_dxi, J] = jacobian(this)
            if ~isempty(this.mapping_unit_)
                [dx_dxi, J] = this.mapping_unit_.calJacobian();
            else
                dx_dxi = []; J = [];
                disp('Call queryAt first');
            end
        end
        
        function normal_vector = normalVector(this)
            if ~isempty(this.mapping_unit_)
                normal_vector = this.mapping_unit_.calNormalVector();
            else
                normal_vector = [];
                disp('Call queryAt first');
            end
        end
        
        function tangent_vector = tangentVector(this)
            if ~isempty(this.mapping_unit_)
                tangent_vector = this.mapping_unit_.calTangentVector();
            else
                tangent_vector = [];
                disp('Call queryAt first');
            end
        end
        
        % consider to set as private
        function x = mapping(this)
            if ~isempty(this.mapping_unit_)
                x = this.mapping_unit_.calPhysicalPosition();
            else
                x = [];
                disp('Call queryAt first');
            end
        end
            
        function xi = inverseMapping(this, x, varargin)                           
            import Utility.NurbsUtility.NurbsType
            switch this.patch_.nurbs_data_.type_
                case NurbsType.Curve
                    % Newton iteration for solving parametric coordinate
                    % given x = f(s), for specific x, find s.
                    
                    % Initial guessing
                    if isempty(varargin)
                        eps = rand(1)*1e-5;
                        xi = 0.5*(max(this.patch_.nurbs_data_.knot_vectors_{1}) + min(this.patch_.nurbs_data_.knot_vectors_{1}));
                        
                        t_1 = xi-eps;
                        [~, ~, res_1] = this.eval(t_1, physical_coordinate);
                        
                        t_2 = xi+eps;
                        [~, ~, res_2] = this.eval(t_2, physical_coordinate);
                        
                        if (res_1 <= res_2)
                            xi = t_1;
                        else
                            xi = t_2;
                        end
                    else
                        xi = varargin{1};
                    end
     
                    iter_times = 15;
                    [xi, residual, cnt] = ...
                        this.NewtonIteration(this.patch_, xi, physical_coordinate, iter_times);
                     
                    if cnt > iter_times
                        disp('Iteration failed with the current initial guess. Activate the re-initialization process.')
                        xi = this.reInitializedParametricCoordinate();
                        
                        [xi, residual, cnt] = ...
                            this.NewtonIteration(this.patch_, xi, physical_coordinate, iter_times);
                    end
                    
                    str = ['cnt: ', num2str(cnt)];
                    disp(str);
                    str = ['residual: ', num2str(residual)];
                    disp(str);
                    str = ['xi: ', num2str(xi)];
                    disp(str);
                otherwise % Plane or Surface
                    % Newton iteration for solving parametric coordinate
                    % given x = f(s), for specific x, find s.
                    
                    % Initial guessing
                    if isempty(varargin)
                        eps = rand(1)*1e-1;
                        xi = 0.5*[this.patch_.nurbs_data_.knot_vectors_{1}(1) +  this.patch_.nurbs_data_.knot_vectors_{1}(end), ...
                            this.patch_.nurbs_data_.knot_vectors_{2}(1) +  this.patch_.nurbs_data_.knot_vectors_{2}(end)];
                        
                        xi_test{1} = xi+[eps 0];
                        [~, ~, res_1] = this.eval(xi_test{1}, x);
                        
                        xi_test{2} = xi-[eps 0];
                        [~, ~, res_2] = this.eval(xi_test{2}, x);
                        
                        xi_test{3} = xi+[0 eps];
                        [~, ~, res_3] = this.eval(xi_test{3}, x);
                        
                        xi_test{4} = xi-[0 eps];
                        [~, ~, res_4] = this.eval(xi_test{4}, x);
                        
                        
                        [~,I] = min([res_1 res_2 res_3 res_4]);
                        
                        xi = xi_test{I};
                        
                    else
                        xi = varargin{1};
                    end
                    
                    iter_times = 15;
                    [xi, residual, cnt] = ...
                        this.NewtonIteration(xi, x, iter_times);
                     
                    if cnt > iter_times
                        disp('Iteration failed with the current initial guess. Need to activate the re-initialization process. Still under programming...')
                    end
                    
                    str = ['cnt: ', num2str(cnt)];
                    disp(str);
                    str = ['residual: ', num2str(residual)];
                    disp(str);
                    str = ['xi: ', num2str(xi)];
                    disp(str);
                    
            end
        
        end
   
    end
    
    methods (Access = private)
        function [dC_dt, F, residual] = eval(this, parametric_coordinate, physical_coordinate)            
            this.queryAt(parametric_coordinate);

            C = this.mapping();
            dC_dt = this.tangentVector();
            
            F = (C-physical_coordinate);
            residual = norm(F);            
        end
        
        function [parametric_coordinate, residual, cnt] = NewtonIteration(this, parametric_coordinate, physical_coordinate, iter_times)
            [dC_dt, F, residual] = this.eval(parametric_coordinate, physical_coordinate);
            
            cnt = 0;
            switch this.patch_.dim_
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
                        
                        [dC_dt, F, residual] = this.eval(parametric_coordinate, physical_coordinate);
                        
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
                                          
                        [dC_dt, F, residual] = this.eval(parametric_coordinate, physical_coordinate);
                        
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

