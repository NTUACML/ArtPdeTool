classdef NurbsTools
    %NURBSTOOLS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = private)
        basis_function_
        nurbs_data_
    end
    
    methods
        function this = NurbsTools(basis_function)
            this.basis_function_ = basis_function;
            
            nurbs_patch = basis_function.topology_data_.getDomainPatch();
            this.nurbs_data_ = nurbs_patch.nurbs_data_;
        end
        
        function plotParametricMesh(this)
            switch this.nurbs_data_.getGeometryDimension()
                case 1
                    unique_knot = unique(this.nurbs_data_.knot_vectors_{1});
                    plot(unique_knot, unique_knot*0, 'ko');
                case 2
                    unique_knot_1 = unique(this.nurbs_data_.knot_vectors_{1});
                    unique_knot_2 = unique(this.nurbs_data_.knot_vectors_{2});
                    unique_knot_3 = 0;
                    
                    this.plotMeshPatch(unique_knot_1, unique_knot_2, unique_knot_3);
                case 3
                    unique_knot_1 = unique(this.nurbs_data_.knot_vectors_{1});
                    unique_knot_2 = unique(this.nurbs_data_.knot_vectors_{2});
                    unique_knot_3 = unique(this.nurbs_data_.knot_vectors_{3});
                    
                    % Plot bottom face
                    this.plotMeshPatch(unique_knot_1, unique_knot_2, 0);
                    % Plot top face
                    this.plotMeshPatch(unique_knot_1, unique_knot_2, 1);
                    % Plot east face
                    this.plotMeshPatch(unique_knot_1, 1, unique_knot_3);
                    % Plot west face
                    this.plotMeshPatch(unique_knot_1, 0, unique_knot_3);
                    % Plot rare face
                    this.plotMeshPatch(0, unique_knot_2, unique_knot_3);
                    % Plot front face
                    this.plotMeshPatch(1, unique_knot_2, unique_knot_3);
            end
            
        end
        
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
                query_unit.query_protocol_ = {Region.Domain, xi(i,:)};
                this.basis_function_.query(query_unit);
                
                non_zero_id = query_unit.non_zero_id_;
                
                for case_name = varargin
                    switch case_name{1}
                        case 'position'
                            R = query_unit.evaluate_basis_{1};
                            position(i,:) = R * this.nurbs_data_.control_points_(non_zero_id,1:3);
                        case 'gradient'
                            for dim_i = 1:geo_dim
                                temp = query_unit.evaluate_basis_{2}(dim_i,:);
                                gradient{dim_i}(i,:) = temp * this.nurbs_data_.control_points_(non_zero_id,1:3);
                            end
                        case 'hassian'
                            %TODO computation of the Hassian matrix
                    end
                end
            end
        end
        
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
                    
                    % Plot bottom face
                    unique_knot_vector = {unique_knot_1, unique_knot_2, 0};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot top face
                    unique_knot_vector = {unique_knot_1, unique_knot_2, 1};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot east face
                    unique_knot_vector = {unique_knot_1, 1, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot west face
                    unique_knot_vector = {unique_knot_1, 0, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot rare face
                    unique_knot_vector = {0, unique_knot_2, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
                    % Plot front face
                    unique_knot_vector = {1, unique_knot_2, unique_knot_3};
                    this.plotSurfaceNurbs(N, unique_knot_vector);
            end
        end
 
    end
    
    methods(Access = private)
        function degreeElevation(this, degree)
            disp('Under development');
        end
        
        function knotInsertion(this, knots)
            disp('Under development');
        end
        
        function plotMeshPatch(~, knot_1, knot_2, knot_3)
            import Utility.Resources.mesh2d
            
            if length(knot_1) == 1
                m = mesh2d(length(knot_2)-1, length(knot_3)-1, 1, 1);
                fv.vertices = [knot_1*ones(m.nn,1), m.xI(:,1), m.xI(:,2)];
            elseif length(knot_2) == 1
                m = mesh2d(length(knot_1)-1, length(knot_3)-1, 1, 1);
                fv.vertices = [m.xI(:,1), knot_2*ones(m.nn,1), m.xI(:,2)];
            elseif length(knot_3) == 1
                m = mesh2d(length(knot_1)-1, length(knot_2)-1, 1, 1);
                fv.vertices = [m.xI(:,1), m.xI(:,2), knot_3*ones(m.nn,1)];
            end
            
            fv.faces = m.connect;
            fv.facevertexcdata = ones(m.nn,1);
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
                    position = this.evaluateNurbs(mesh.xI, 'position');
                    
                    fv.vertices = position;
                    fv.faces = mesh.connect;
                    fv.facevertexcdata = ones(mesh.nn,1);
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
                    if length(knot_1) == 1
                        m = mesh2d(Np(2), Np(3), 1, 1);
                        sample_pnt = [knot_1*ones(m.nn,1), m.xI(:,1), m.xI(:,2)];
                    elseif length(knot_2) == 1
                        m = mesh2d(Np(1), Np(3), 1, 1);
                        sample_pnt = [m.xI(:,1), knot_2*ones(m.nn,1), m.xI(:,2)];
                    elseif length(knot_3) == 1
                        m = mesh2d(Np(1), Np(2), 1, 1);
                        sample_pnt = [m.xI(:,1), m.xI(:,2), knot_3*ones(m.nn,1)];
                    end
                    
                    fv.vertices = this.evaluateNurbs(sample_pnt, 'position');
                    fv.faces = m.connect;
                    fv.facevertexcdata = ones(m.nn,1);
                    patch(fv,'CDataMapping','scaled','EdgeColor','none','FaceColor','interp','FaceAlpha',0.8);
                    
                    % Plot knot mesh using 3d basis functions
                    direction = {[1 0 0]
                        [0 1 0]
                        [0 0 1]};
                    
                    % Start from the knot point from knot_1, generate
                    % sample points along directions (+-)2 & (+-)3
                    for knot_p = unique_knot_vector{1}
                        this.plotKnotLine([knot_p 0 0], direction{2}, Np(2));
                    end
                    
                    for knot_p = unique_knot_vector{1}
                        this.plotKnotLine([knot_p 1 1], -direction{2}, Np(2));
                    end
                    
                    for knot_p = unique_knot_vector{1}
                        this.plotKnotLine([knot_p 0 0], direction{3}, Np(3));
                    end
                    
                    for knot_p = unique_knot_vector{1}
                        this.plotKnotLine([knot_p 1 1], -direction{3}, Np(3));
                    end
                    % Start from the knot point from knot_2, generate
                    % sample points along directions (+-)1 & (+-)3
                    for knot_p = unique_knot_vector{2}
                        this.plotKnotLine([0 knot_p 0], direction{1}, Np(1));
                    end
                    
                    for knot_p = unique_knot_vector{2}
                        this.plotKnotLine([1 knot_p 1], -direction{1}, Np(1));
                    end
                    
                    for knot_p = unique_knot_vector{2}
                        this.plotKnotLine([0 knot_p 0], direction{3}, Np(3));
                    end
                    
                    for knot_p = unique_knot_vector{2}
                        this.plotKnotLine([1 knot_p 1], -direction{3}, Np(3));
                    end
                    % Start from the knot point from knot_3, generate
                    % sample points along directions (+-)1 & (+-)2
                    for knot_p = unique_knot_vector{3}
                        this.plotKnotLine([0 0 knot_p], direction{1}, Np(1));
                    end
                    
                    for knot_p = unique_knot_vector{3}
                        this.plotKnotLine([1 1 knot_p], -direction{1}, Np(1));
                    end
                    
                    for knot_p = unique_knot_vector{3}
                        this.plotKnotLine([0 0 knot_p], direction{2}, Np(2));
                    end
                    
                    for knot_p = unique_knot_vector{3}
                        this.plotKnotLine([1 1 knot_p], -direction{2}, Np(2));
                    end
                    
            end
        end
        
        function plotKnotLine(this, pStart, direction, N)
            t = linspace(0,1,N);
            sample_pnt = zeros(N, size(pStart, 2));
            
            for i = 1:N
                sample_pnt(i,:) = pStart + t(i)*direction;
            end
            
            position = this.evaluateNurbs(sample_pnt, 'position');
            plot3(position(:,1), position(:,2), position(:,3), 'k-');
        end
        
    end
    
end

