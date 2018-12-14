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
        
        
    end
    
    methods(Access = private)
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
    end
    
end

