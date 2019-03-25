classdef NurbsTools < handle
    properties(Access = private)
        basis_function_
        nurbs_data_
    end
    
    methods
        % Constructor
        function this = NurbsTools(basis_function)
            this.basis_function_ = basis_function;
            
            nurbs_patch = basis_function.topology_data_.getDomainPatch();
            this.nurbs_data_ = nurbs_patch.nurbs_data_;
        end
        % Plot parametric mesh formed by uniqued knot vectors
        function plotParametricMesh(this)
            switch this.nurbs_data_.getGeometryDimension()
                case 1
                    unique_knot = unique(this.nurbs_data_.knot_vectors_{1});
                    plot(unique_knot, unique_knot*0, 'ko');
                    xlabel('\xi');
                case 2
                    unique_knot_1 = unique(this.nurbs_data_.knot_vectors_{1});
                    unique_knot_2 = unique(this.nurbs_data_.knot_vectors_{2});
                    unique_knot_3 = 0;
                    
                    this.plotMeshPatch(unique_knot_1, unique_knot_2, unique_knot_3);
                    xlabel('\xi');
                    ylabel('\eta');
                case 3
                    unique_knot_1 = unique(this.nurbs_data_.knot_vectors_{1});
                    unique_knot_2 = unique(this.nurbs_data_.knot_vectors_{2});
                    unique_knot_3 = unique(this.nurbs_data_.knot_vectors_{3});
                    
                    % Plot face zeta = 0
                    this.plotMeshPatch(unique_knot_1, unique_knot_2, 0);
                    % Plot face zeta = 1
                    this.plotMeshPatch(unique_knot_1, unique_knot_2, 1);
                    % Plot face eta = 0
                    this.plotMeshPatch(unique_knot_1, 0, unique_knot_3);
                    % Plot face eta = 1
                    this.plotMeshPatch(unique_knot_1, 1, unique_knot_3);
                    % Plot face xi = 0
                    this.plotMeshPatch(0, unique_knot_2, unique_knot_3);
                    % Plot face xi = 1
                    this.plotMeshPatch(1, unique_knot_2, unique_knot_3);
                    
                    xlabel('\xi');
                    ylabel('\eta');
                    zlabel('\zeta');
            end
            
        end
        % Evaluate nurbs or its derivatives or its hassian matrix at xi
        function [position, gradient, hassian] = evaluateNurbs(this, xi, varargin)
            if ~isequal(size(xi,2), this.nurbs_data_.getGeometryDimension())
                disp('Input parametric coordinates dimension are mismatched!');
                return;
            end
            
            import BasisFunction.IGA.QueryUnit
            import Utility.BasicUtility.Region
            
            query_unit = QueryUnit();
            
            % Current shape funciton have to query point by point
            geo_dim = this.nurbs_data_.getGeometryDimension();
            position = zeros(size(xi,1), 3);
            gradient = cell(1,geo_dim);
            hassian = cell(1,geo_dim*(geo_dim+1)/2);
            
            if isempty(varargin)
                % default option
                varargin = {'position', 'gradient', 'hassian'};
            end
            
            for i = 1:size(xi,1)
                if any(strcmp(varargin, 'hassian'))
                    query_unit.query_protocol_ = {Region.Domain, xi(i,:), 2};
                    this.basis_function_.query(query_unit);
                    
                    non_zero_id = query_unit.non_zero_id_;
                    R = query_unit.evaluate_basis_{1};
                    position(i,:) = R * this.nurbs_data_.control_points_(non_zero_id,1:3);
                    for dim_i = 1:geo_dim
                        temp = query_unit.evaluate_basis_{2}(dim_i,:);
                        gradient{dim_i}(i,:) = temp * this.nurbs_data_.control_points_(non_zero_id,1:3);
                    end                    
                    %TODO computation of the Hassian matrix
                    hassian = [];
                elseif any(strcmp(varargin, 'gradient'))
                    query_unit.query_protocol_ = {Region.Domain, xi(i,:), 1};
                    this.basis_function_.query(query_unit);
                    
                    non_zero_id = query_unit.non_zero_id_;
                    R = query_unit.evaluate_basis_{1};
                    position(i,:) = R * this.nurbs_data_.control_points_(non_zero_id,1:3);
                    for dim_i = 1:geo_dim
                        temp = query_unit.evaluate_basis_{2}(dim_i,:);
                        gradient{dim_i}(i,:) = temp * this.nurbs_data_.control_points_(non_zero_id,1:3);
                    end
                elseif any(strcmp(varargin, 'position'))
                    query_unit.query_protocol_ = {Region.Domain, xi(i,:), 0};
                    this.basis_function_.query(query_unit);
                    
                    non_zero_id = query_unit.non_zero_id_;
                    R = query_unit.evaluate_basis_{1};
                    position(i,:) = R * this.nurbs_data_.control_points_(non_zero_id,1:3);
                end
                
                
%                 for case_name = varargin
%                     switch case_name{1}
%                         case 'position'
%                             query_unit.query_protocol_ = {Region.Domain, xi(i,:), 0};
%                             this.basis_function_.query(query_unit);
%                             
%                             non_zero_id = query_unit.non_zero_id_;
%                             R = query_unit.evaluate_basis_{1};
%                             position(i,:) = R * this.nurbs_data_.control_points_(non_zero_id,1:3);
%                         case 'gradient'
%                             query_unit.query_protocol_ = {Region.Domain, xi(i,:), 1};
%                             this.basis_function_.query(query_unit);
%                             
%                             non_zero_id = query_unit.non_zero_id_;
%                             for dim_i = 1:geo_dim
%                                 temp = query_unit.evaluate_basis_{2}(dim_i,:);
%                                 gradient{dim_i}(i,:) = temp * this.nurbs_data_.control_points_(non_zero_id,1:3);
%                             end
%                         case 'hassian'
%                             %TODO computation of the Hassian matrix
%                     end
%                 end
            end
        end
        % Plot nurbs geometry
        function plotNurbs(this, varargin)
            geo_dim = this.nurbs_data_.getGeometryDimension();
            
            if ~isempty(varargin)
                N = varargin{1};
            else
                N = 11*ones(1, geo_dim);
            end
            
            switch geo_dim
                case 1
                    sample_pnt = linspace(0,1,N)';
                    position = this.evaluateNurbs(sample_pnt, 'position');
                    plot3(position(:,1), position(:,2), position(:,3), 'r-');
                    
                    unique_knot = unique(this.nurbs_data_.knot_vectors{1});
                    position = this.evaluateNurbs(unique_knot, 'position');
                    plot3(position(:,1), position(:,2), position(:,3), 'k.');
                case 2
                    unique_knot_vector{1} = unique(this.nurbs_data_.knot_vectors_{1});
                    unique_knot_vector{2} = unique(this.nurbs_data_.knot_vectors_{2});
                    
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                case 3
                    % Only surface nurbs are plotted for 3d case
                    unique_knot_1 = unique(this.nurbs_data_.knot_vectors_{1});
                    unique_knot_2 = unique(this.nurbs_data_.knot_vectors_{2});
                    unique_knot_3 = unique(this.nurbs_data_.knot_vectors_{3});                    
                    
                    % Plot face xi = 0
                    unique_knot_vector = {0, unique_knot_2, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot face xi = 1
                    unique_knot_vector = {1, unique_knot_2, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot face eta = 0
                    unique_knot_vector = {unique_knot_1, 0, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot face eta = 1
                    unique_knot_vector = {unique_knot_1, 1, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot face zeta = 0
                    unique_knot_vector = {unique_knot_1, unique_knot_2, 0};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot face zeta = 1
                    unique_knot_vector = {unique_knot_1, unique_knot_2, 1};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    
                    % Plot knot mesh using 3d basis functions
                    direction = {[1 0 0]
                        [0 1 0]
                        [0 0 1]};
                    
                    % Start from the knot point from knot_1, generate
                    % sample points along directions (+-)2 & (+-)3
                    for knot_p = unique_knot_1
                        this.plotKnotLine([knot_p 0 0], direction{2}, N(2));
                    end
                    
                    for knot_p = unique_knot_1
                        this.plotKnotLine([knot_p 1 1], -direction{2}, N(2));
                    end
                    
                    for knot_p = unique_knot_1
                        this.plotKnotLine([knot_p 0 0], direction{3}, N(3));
                    end
                    
                    for knot_p = unique_knot_1
                        this.plotKnotLine([knot_p 1 1], -direction{3}, N(3));
                    end
                    % Start from the knot point from knot_2, generate
                    % sample points along directions (+-)1 & (+-)3
                    for knot_p = unique_knot_2
                        this.plotKnotLine([0 knot_p 0], direction{1}, N(1));
                    end
                    
                    for knot_p = unique_knot_2
                        this.plotKnotLine([1 knot_p 1], -direction{1}, N(1));
                    end
                    
                    for knot_p = unique_knot_2
                        this.plotKnotLine([0 knot_p 0], direction{3}, N(3));
                    end
                    
                    for knot_p = unique_knot_2
                        this.plotKnotLine([1 knot_p 1], -direction{3}, N(3));
                    end
                    % Start from the knot point from knot_3, generate
                    % sample points along directions (+-)1 & (+-)2
                    for knot_p = unique_knot_3
                        this.plotKnotLine([0 0 knot_p], direction{1}, N(1));
                    end
                    
                    for knot_p = unique_knot_3
                        this.plotKnotLine([1 1 knot_p], -direction{1}, N(1));
                    end
                    
                    for knot_p = unique_knot_3
                        this.plotKnotLine([0 0 knot_p], direction{2}, N(2));
                    end
                    
                    for knot_p = unique_knot_3
                        this.plotKnotLine([1 1 knot_p], -direction{2}, N(2));
                    end
                    
                    xlabel('x');
                    ylabel('y');
                    zlabel('x');
            end
        end
        % Plot mesh formed by control points 
        function plotControlMesh(this)
            geo_dim = this.nurbs_data_.getGeometryDimension();
            
            switch geo_dim
                case 1
                    plot3(this.nurbs_data_.control_points_(:,1), this.nurbs_data_.control_points_(:,2), this.nurbs_data_.control_points_(:,3), '--ro');
                case 2
                    plot3(this.nurbs_data_.control_points_(:,1), this.nurbs_data_.control_points_(:,2), this.nurbs_data_.control_points_(:,3), 'ro');
                    
                    import Utility.Resources.mesh2d
                    mesh = mesh2d(this.nurbs_data_.basis_number_(1)-1, this.nurbs_data_.basis_number_(2)-1, 1, 1);
                    
                    import Utility.Resources.quadplot
                    quadplot(mesh.connect, this.nurbs_data_.control_points_(:,1), this.nurbs_data_.control_points_(:,2), this.nurbs_data_.control_points_(:,3));
                case 3
                    plot3(this.nurbs_data_.control_points_(:,1), this.nurbs_data_.control_points_(:,2), this.nurbs_data_.control_points_(:,3), 'ro');
                    
                    import Utility.Resources.mesh3d
                    mesh = mesh3d(this.nurbs_data_.basis_number_(1)-1, this.nurbs_data_.basis_number_(2)-1, this.nurbs_data_.basis_number_(3)-1, 1, 1, 1);
                    
                    import Utility.Resources.hexaplot
                    hexaplot(mesh.connect, this.nurbs_data_.control_points_(:,1), this.nurbs_data_.control_points_(:,2), this.nurbs_data_.control_points_(:,3));
            end
            
            
        end
        
        
    end
    
    methods(Access = private)
        function plotMeshPatch(~, knot_1, knot_2, knot_3)
            import Utility.Resources.mesh2d
            
            if length(knot_1) == 1
                m = mesh2d(length(knot_2)-1, length(knot_3)-1, 1, 1);
                [yy, xx] = meshgrid(knot_3, knot_2);
                fv.vertices = [knot_1*ones(m.node_number,1), xx(:), yy(:)];
            elseif length(knot_2) == 1
                m = mesh2d(length(knot_1)-1, length(knot_3)-1, 1, 1);
                [yy, xx] = meshgrid(knot_3, knot_1);
                fv.vertices = [xx(:), knot_2*ones(m.node_number,1), yy(:)];
            elseif length(knot_3) == 1
                m = mesh2d(length(knot_1)-1, length(knot_2)-1, 1, 1);
                [yy, xx] = meshgrid(knot_2, knot_1);
                fv.vertices = [xx(:), yy(:), knot_3*ones(m.node_number,1)];
            end
            
            fv.faces = m.connect;
            fv.facevertexcdata = ones(m.node_number,1);
            patch(fv,'CDataMapping','scaled','EdgeColor','k','FaceColor','interp','FaceAlpha',0.8);
        end
        
        function plotSurfaceNurbs(this, varargin)
            import Utility.Resources.mesh2d
            
            switch this.nurbs_data_.getGeometryDimension()
                case 2
                    Np = varargin{1};
                    unique_knot_vector = varargin{2};
                    
                    % Plot surface nurbs using 2d basis functions
                    mesh = mesh2d(Np(1), Np(2), 1, 1);
                    position = this.evaluateNurbs(mesh.node, 'position');
                    
                    fv.vertices = position;
                    fv.faces = mesh.connect;
                    fv.facevertexcdata = ones(mesh.node_number,1);
                    patch(fv,'CDataMapping','scaled','EdgeColor','none','FaceColor','interp','FaceAlpha',0.8);
                    
                    % Plot knot mesh
                    direction = {[1 0] [0 1]};
                    
                    for knot_p = unique_knot_vector{1}
                        this.plotKnotLine([knot_p 0], direction{2}, Np(2));
                    end
                    
                    for knot_p = unique_knot_vector{2}
                        this.plotKnotLine([0 knot_p], direction{1}, Np(1));
                    end
                case 3
                    Np = varargin{1};
                    unique_knot_vector = varargin{2};
                    
                    % Plot surface nurbs using 3d basis functions
                    if length(unique_knot_vector{1}) == 1
                        m = mesh2d(Np(2), Np(3), 1, 1);
                        sample_pnt = [unique_knot_vector{1}*ones(m.node_number,1), m.node(:,1), m.node(:,2)];
                    elseif length(unique_knot_vector{2}) == 1
                        m = mesh2d(Np(1), Np(3), 1, 1);
                        sample_pnt = [m.node(:,1), unique_knot_vector{2}*ones(m.node_number,1), m.node(:,2)];
                    elseif length(unique_knot_vector{3}) == 1
                        m = mesh2d(Np(1), Np(2), 1, 1);
                        sample_pnt = [m.node(:,1), m.node(:,2), unique_knot_vector{3}*ones(m.node_number,1)];
                    end
                    
                    fv.vertices = this.evaluateNurbs(sample_pnt, 'position');
                    fv.faces = m.connect;
                    fv.facevertexcdata = ones(m.node_number,1);
                    patch(fv,'CDataMapping','scaled','EdgeColor','none','FaceColor','interp','FaceAlpha',0.8);
            end
        end
        
        function plotKnotLine(this, pStart, direction, N)
            t = linspace(0,1,N);
            sample_pnt = zeros(N, size(pStart, 2));
            
            for i = 1:N
                sample_pnt(i,:) = pStart + t(i)*direction;
            end
            
            position = this.evaluateNurbs(sample_pnt, 'position');
            plot3(position(:,1), position(:,2), position(:,3), 'k-', 'LineWidth', 1.5);
        end
        
        function [Qw, UQ] = KnotIns(this, p, Pw, UP, u, r)
            % Input: p, UP, Pw, u, r,
            % Output: UQ, Qw
            import BasisFunction.IGA.NurbsBasisFunction
            
            [N_m, N_n, N_q] = size(Pw);
            np = length(UP)-p-2;
            k = NurbsBasisFunction.FindSpan(np, p, u, UP);
            k = k+1;
            mp = np+p+1;
            nq = np+r;
            
            UQ=zeros(1,length(UP)+r);
            
            for i = 1:k
                UQ(i) = UP(i);
            end
            for i = 1:r
                UQ(k+i) = u;
            end
            for i = (k+1):(mp+1)
                UQ(i+r) = UP(i);
            end
            
            for j = 1:r
                L = k-p+j;
                for i = 0:(p-j)
                    alpha(i+1, j) = (u-UP(L+i))/(UP(i+1+k)-UP(L+i));
                end
            end
            
            for q = 1:N_q
                for n = 1:N_n
                    Local_Pw = [];
                    for m = 1:N_m
                        Local_Pw(m, :) = [Pw{m, n, q}];
                    end
                    [row_n, col_n] = size(Local_Pw);
                    for col = 1:col_n
                        for i = 0:(k-p-1)
                            Local_Qw(i+1, col) = Local_Pw(i+1, col);
                        end
                        for i = k:(np+1)
                            Local_Qw(i+r, col) = Local_Pw(i, col);
                        end
                        for i = 0:p
                            Rw(i+1) = Local_Pw(k-p+i, col);
                        end
                        for j = 1:r
                            L = k-p+j;
                            for i = 0:(p-j)
                                Rw(i+1) = alpha(i+1,j) * Rw(i+2) + (1.0-alpha(i+1,j)) * Rw(i+1);
                                Local_Qw(L, col) = Rw(1);
                                Local_Qw(k+r-j, col) = Rw(p-j+1);
                            end
                            for i = (L+1):k
                                Local_Qw(i, col) = Rw(i-L+1);
                            end
                        end
                    end
                    [rowQ,colQ] = size(Local_Qw);
                    for i = 1:rowQ
                        Qw{i, n, q} = Local_Qw(i, :);
                    end
                end
            end
        end
        
        function [new_points, new_knots, new_basis_number] = Nurb_KnotIns(this, u)
            % Input: p(matrix), knots(cell), point(matrix), u(cell), basis_num(cell)
            % Output: new_points, new_knots
            import Utility.BasicUtility.TensorProduct
            
            knots = this.nurbs_data_.knot_vectors_;
            p = this.nurbs_data_.order_;
            point = this.nurbs_data_.control_points_(:,:);
            
            % transform to homogeneous coordinates
            for i = 1:size(point,1)
                point(i,1:3) = point(i,1:3)*point(i,4);
            end
                        
            basis_n = this.nurbs_data_.basis_number_;
            
            while length(basis_n) < 3
                basis_n(1,end+1) = 1;
            end
            
            %Rearrange point list to cubic
            TD = TensorProduct({basis_n(1) basis_n(2) basis_n(3)});
            point_L = basis_n(1) * basis_n(2) * basis_n(3);
            for k = 1:point_L
                pos = TD.to_local_index(k);
                Pw(pos{1},pos{2},pos{3}) = {point(k,:)};
            end
            
            Dim = length(knots);
            switch Dim
                case 1
                    UP = knots{1};
                    u_u = u{1};
                    %insert u-durection
                    if isempty(u_u)
                        UQ = UP;
                    else
                        uni = unique(u_u);
                        n = histc(u_u,uni);
                        Qw = Pw;
                        U = UP;
                        for i = 1:length(uni)
                            local_u = uni(i);
                            r = n(i);
                            [Qw, U] = this.KnotIns(p(1), Qw, U, local_u, r); %
                        end
                        UQ = U;
                        Pw = Qw;
                    end
                    new_knots = {UQ};
                    
                case 2
                    UP = knots{1}; VP = knots{2};
                    u_u = u{1}; v_u = u{2};
                    %insert u-durection
                    if isempty(u_u)
                        UQ = UP;
                    else
                        uni = unique(u_u);
                        n = histc(u_u,uni);
                        Qw = Pw;
                        U = UP;
                        for i = 1:length(uni)
                            local_u = uni(i);
                            r = n(i);
                            [Qw, U] = this.KnotIns(p(1), Qw, U, local_u, r); %
                        end
                        UQ = U;
                        Pw = Qw;
                    end
                    %insert v-durection
                    if isempty(v_u)
                        VQ = VP;
                    else
                        uni = unique(v_u);
                        n = histc(v_u,uni);
                        Qw = permute(Pw, [2 1 3]);
                        U = VP;
                        for i = 1:length(uni)
                            local_u = uni(i);
                            r = n(i);
                            [Qw, U] = this.KnotIns(p(2), Qw, U, local_u, r); %
                        end
                        VQ = U;
                        Pw = permute(Qw,[2 1 3]);
                    end
                    new_knots = {UQ, VQ};
                    
                case 3
                    UP = knots{1}; VP = knots{2}; WP = knots{3};
                    u_u = u{1}; v_u = u{2}; w_u = u{3};
                    %insert u-durection
                    if isempty(u_u)
                        UQ = UP;
                    else
                        uni = unique(u_u);
                        n = histc(u_u,uni);
                        Qw = Pw;
                        U = UP;
                        for i = 1:length(uni)
                            local_u = uni(i);
                            r = n(i);
                            [Qw, U] = this.KnotIns(p(1), Qw, U, local_u, r); %
                        end
                        UQ = U;
                        Pw = Qw;
                    end
                    
                    %insert v-durection
                    if isempty(v_u)
                        VQ = VP;
                    else
                        uni = unique(v_u);
                        n = histc(v_u,uni);
                        Qw = permute(Pw,[2 1 3]);
                        U = VP;
                        for i = 1:length(uni)
                            local_u = uni(i);
                            r = n(i);
                            [Qw, U] = this.KnotIns(p(2), Qw, U, local_u, r); %
                        end
                        VQ = U;
                        Pw = permute(Qw,[2 1 3]);
                    end
                    
                    %insert w-durection
                    if isempty(w_u)
                        WQ = WP;
                    else
                        uni = unique(w_u);
                        n = histc(w_u,uni);
                        Qw = permute(Pw,[3 2 1]);
                        U = WP;
                        for i = 1:length(uni)
                            local_u = uni(i);
                            r = n(i);
                            [Qw, U] = this.KnotIns(p(3), Qw, U, local_u, r);%
                        end
                        WQ = U;
                        Pw = permute(Qw,[3 2 1]);
                    end
                    new_knots = {UQ, VQ, WQ};
            end
            
            %Rearrange cubic control point to point-list type
            [N_i, N_j, N_k] = size(Pw);
            TD_3 = TensorProduct({N_i N_j N_k});
            for k = 1:N_k
                for j = 1:N_j
                    for i = 1:N_i
                        global_index = TD_3.to_global_index({i j k});
                        new_points(global_index, :) = Pw{i, j, k};
                    end
                end
            end
            
            new_basis_number = size(Pw);
        end

        function [Qw, Uh] = DegreeElev(this, p, Pw, UP, t)
            % Input: p, UP, Pw, t
            % Output: Uh, Qw
            [N_m, N_n, N_q] = size(Pw);
            n = length(UP)-p-2;
            m = n+p+1;
            ph = p+t;
            ph2 = floor(ph/2);

            %% Compute Bezier degree elevation coefficients
            bezalfs(1, 1) = 1;
            bezalfs(p+1, ph+1) = 1;
            for i = 1:ph2
               inv = 1.0 / Bin(ph, i);
               mpi = min(p, i);
               for j = max(0, i-t):mpi
                   bezalfs(j+1, i+1) = inv*Bin(p, j)*Bin(t, i-j); 
               end
            end
            for i = (ph2+1):(ph-1)
                mpi = min(p, i);
                for j = max(0, i-t):mpi
                    bezalfs(j+1, i+1) = bezalfs(p-j+1, ph-i+1);
                end
            end
            ua = UP(1);
            for i = 0:ph
               Uh(i+1) = ua; 
            end

            for qq = 1:N_q
            for nn = 1:N_n
                ua = UP(1);
                Local_Pw = [];
                Local_Qw=[];
                mh = ph;
                kind = ph+1;
                r = -1;
                a = p;
                b = p+1;
                cind = 1;
                for mm = 1:N_m  
                    Local_Pw(mm, :) = [Pw{mm, nn, qq}];
                end
            %% Initialize first Bezier seg
                [~, col_n] = size(Local_Pw);
                for col = 1:col_n
                    Local_Qw(1, col) = Local_Pw(1, col);
                    for i = 0:p
                       bpts(i+1, col) = Local_Pw(i+1, col); 
                    end
                end
            % Big loop thru knot vector
            while b < m
                i = b;
                while b < m && UP(b+1) == UP(b+2)
                    b = b+1;
                end
                mul = b - i + 1;
                mh = mh + mul + t;
                ub = UP(b+1);
                oldr = r;
                r = p-mul;

                % Insert knot u(b) r times
                if oldr > 0 
                    lbz = floor((oldr+2)/2);
                else 
                    lbz = 1;
                end    
                if r > 0
                    rbz = ph-floor((r+1)/2);
                else
                    rbz = ph;
                end

                % Insert knot to get Bezier segment
                if r > 0 
                    numer = ub-ua;
                    for k = p:-1:(mul+1)
                        alfs(k-mul) = numer / (UP(a+k+1)-ua);
                    end
                    for j = 1:r
                        save = r - j;
                        s = mul + j;
                        for col = 1:col_n
                            for k = p:-1:s
                                bpts(k+1,col) = alfs(k-s+1)*bpts(k+1,col) + (1.0-alfs(k-s+1))*bpts(k,col);
                            end
                            Nextbpts(save+1,col)=bpts(p+1,col);
                        end
                    end
                end
                % Degree elevate Bezier
                for i = lbz:ph
                    for col = 1:col_n
                        ebpts(i+1, col) = 0;
                        mpi = min(p, i);
                        for j = max(0, i-t):mpi
                            ebpts(i+1, col) = ebpts(i+1, col) + bezalfs(j+1, i+1)*bpts(j+1, col);
                        end
                    end
                end
                % Must remove knot u=U(a) oldr times 
                if oldr > 1
                    first = kind-2;
                    last = kind;
                    den = ub - ua;
                    bet = floor((ub-Uh(kind)) / den);
                    for tr = 1:(oldr-1)
                        i = first;
                        j = last;
                        kj = j-kind+1;
                        while (j-i) > tr
                            if i < cind
                                alf = (ub-Uh(i+1)) / (ua-Uh(i+1));
                                for col = 1:col_n
                                    Local_Qw(i+1, col) = alf*Local_Qw(i+1, col) + (1.0-alf)*Local_Qw(i-1+1, col);                  
                                end
                            end
                            if j >= lbz
                                if (j-tr) <= (kind-ph+oldr)
                                    gam = (ub-Uh(j-tr+1)) / den;
                                    for col = 1:col_n
                                        ebpts(kj+1, col) = gam*ebpts(kj+1, col) + (1.0-gam)*ebpts(kj+2, col);
                                    end
                                else
                                    for col = 1:col_n
                                        ebpts(kj+1, col) = bet*ebpts(kj+1, col) + (1.0-bet)*ebpts(kj+2, col);
                                    end
                                end
                            end
                            i = i+1;
                            j = j-1;
                            kj = kj-1;
                        end
                        first = first-1;
                        last = last+1;
                    end
                end

                % Load the knot ua
                if a ~= p
                    for i = 0:(ph-oldr-1)
                        Uh(kind+1) = ua;
                        kind = kind+1;
                    end
                end
                for j = lbz:rbz
                    for col = 1:col_n
                        Local_Qw(cind+1, col) = ebpts(j+1, col);
                    end
                    cind = cind+1;
                end
                if b < m
                    for col = 1:col_n
                        for j = 0:(r-1)
                            bpts(j+1, col) = Nextbpts(j+1, col);
                        end
                        for j = r:p
                            bpts(j+1, col) = Local_Pw(b-p+j+1, col);
                        end    
                    end
                    a = b;
                    b = b+1;
                    ua = ub;
                else
                    for i = 0:ph
                        Uh(kind+i+1) = ub;
                    end
                end 
            end % End big while loop

            [rowQ, ~] = size(Local_Qw);
            for i = 1:rowQ
                Qw{i, nn, qq} = Local_Qw(i, :);
            end
            end
            end
            function b = Bin(p,i)
                b = factorial(p) / (factorial(i)*factorial(p-i));
            end
        end

        function [new_points, new_knots, new_basis_number, new_order] = Nurb_DegElev(this, t)  
            % Input: p(matrix), knots(cell), point(matrix), t(matrix), basis_num(matrix)
            % Output: new_points, new_knots, new_basis_number, new_order
            import Utility.BasicUtility.TensorProduct

            knots = this.nurbs_data_.knot_vectors_;
            p = this.nurbs_data_.order_;
            point = this.nurbs_data_.control_points_(:,:);
            basis_n = this.nurbs_data_.basis_number_;
            
            % transform to homogeneous coordinates
            for i = 1:size(point,1)
                point(i,1:3) = point(i,1:3)*point(i,4);
            end

            while length(basis_n) < 3
                basis_n(1, end+1) = 1;
            end

            %Rearrange point list to cubic
            TD = TensorProduct({basis_n(1) basis_n(2) basis_n(3)});
            point_L = basis_n(1) * basis_n(2) * basis_n(3);
            for k = 1:point_L
                pos = TD.to_local_index(k);
                Pw(pos{1},pos{2},pos{3}) = {point(k,:)};
            end

            Dim = length(knots);
            switch Dim
                case 1
                    UP = knots{1};
                    t_u = t(1);
                    %insert u-direction
                    if t_u == 0 
                        Uh = UP;
                    else
                        [Qw, Uh] = this.DegreeElev(p(1), Pw, UP, t_u);
                        Pw = Qw;
                    end
                    new_knots = {Uh};

                case 2
                    UP = knots{1}; VP = knots{2};
                    t_u = t(1); t_v = t(2);
                    %elevate u-direction
                    if t_u == 0
                        Uh = UP;
                    else
                        [Qw, Uh] = this.DegreeElev(p(1), Pw, UP, t_u);
                        Pw = Qw;
                    end
                    %elevate v-direction
                    if t_v == 0 
                        Vh = VP;
                    else
                        tempPw = permute(Pw, [2 1 3]);
                        [Qw, Vh] = this.DegreeElev(p(2), tempPw, VP, t_v);
                        Pw = permute(Qw,[2 1 3]);
                    end
                    new_knots = {Uh, Vh};

                case 3
                    UP = knots{1}; VP = knots{2}; WP = knots{3};
                    t_u = t(1); t_v = t(2); t_w = t(3);
                    %insert u-direction
                    if t_u == 0
                        Uh = UP;
                    else
                        [Qw, Uh] = this.DegreeElev(p(1), Pw, UP, t_u);
                        Pw = Qw;
                    end
                    %elevate v-direction
                    if t_v == 0 
                        Vh = VP;
                    else
                        tempPw = permute(Pw, [2 1 3]);
                        [Qw, Vh] = this.DegreeElev(p(2), tempPw, VP, t_v);
                        Pw = permute(Qw,[2 1 3]);
                    end
                    %elevate w-direction
                    if t_w == 0 
                        Wh = WP;
                    else
                        tempPw = permute(Pw,[3 2 1]);
                        [Qw, Wh] = this.DegreeElev(p(3), tempPw, WP, t_w);%
                        Pw = permute(Qw,[3 2 1]);
                    end
                    new_knots = {Uh, Vh, Wh};      
            end

            %Rearrange cubic control point to point-list type
            [N_i, N_j, N_k] = size(Pw);
            TD_3 = TensorProduct({N_i N_j N_k});
            for k = 1:N_k
                for j = 1:N_j 
                    for i = 1:N_i 
                        global_index = TD_3.to_global_index({i j k});
                        new_points(global_index, :) = Pw{i, j, k};
                    end
                end
            end
            new_basis_number = size(Pw);
            new_order = this.nurbs_data_.order_ + t;
        end

        % These two functions are moved here as private functions
        function degreeElevation(this, degree)
            [new_points, new_knots, new_basis_number, new_order] = this.Nurb_DegElev(degree);
            import Utility.BasicUtility.PointList  
            
            % transform to Cartesian coordinates
            for i = 1:size(new_points, 1)
                new_points(i,1:3) = new_points(i,1:3)/new_points(i,4);
            end
            
            this.nurbs_data_.knot_vectors_ = new_knots;
            this.nurbs_data_.order_ = new_order;
            this.nurbs_data_.basis_number_ = new_basis_number;
            this.nurbs_data_.control_points_ = PointList(new_points);
            
            this.basis_function_.num_basis_ = prod(this.nurbs_data_.basis_number_);
            this.basis_function_.topology_data_.point_data_ = this.nurbs_data_.control_points_;
        end
        
        function knotInsertion(this, knots)
            [new_points, new_knots, new_basis_number] = this.Nurb_KnotIns(knots);
            import Utility.BasicUtility.PointList  
            
            % transform to Cartesian coordinates
            for i = 1:size(new_points, 1)
                new_points(i,1:3) = new_points(i,1:3)/new_points(i,4);
            end
            
            this.nurbs_data_.knot_vectors_ = new_knots;
            this.nurbs_data_.basis_number_ = new_basis_number;
            this.nurbs_data_.control_points_ = PointList(new_points);
            
            this.basis_function_.num_basis_ = prod(this.nurbs_data_.basis_number_);
            this.basis_function_.topology_data_.point_data_ = this.nurbs_data_.control_points_;          
        end      
        
    end
    
end

