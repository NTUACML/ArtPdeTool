classdef Nurbs
    
    properties   
        knot_vectors_
        order_
        basis_number_
        type_
        control_points_
    end
    
    properties(Access = private)
        nurbs_tool_object_ = [];
        geometry_dimension_
    end
    
    methods
        function this = Nurbs(knot_vectors, order, control_point_list)
            this.knot_vectors_ = knot_vectors;
            this.order_ = order;
            
            import Utility.NurbsUtility.NurbsType
            this.geometry_dimension_ = size(order,2);
            if this.geometry_dimension_ == 1
                this.type_ = NurbsType.Curve;
            elseif this.geometry_dimension_ == 2
                this.type_ = NurbsType.Surface;
            elseif this.geometry_dimension_ == 3
                this.type_ = NurbsType.Solid;
                disp('Currently not support nurbs solid!');
            end
            
            this.basis_number_ = zeros(1, this.geometry_dimension_);
            for i = 1:this.geometry_dimension_
                this.basis_number_(i) = length(knot_vectors{i})-order(i)-1;
            end
            
            import Utility.BasicUtility.PointList
            this.control_points_ = control_point_list;
            
            % generate nurbs toolbox object
            % 
            if this.geometry_dimension_ == 1
                control_pnt = zeros(4,this.basis_number_(1));
                for i = 1:this.basis_number_(1)
                    control_pnt(:,i) = control_point_list(i,:)';
                    % multiply by weighting
                    control_pnt(1:end-1,i) = control_pnt(1:end-1,i)*control_pnt(end,i);
                end
                this.nurbs_tool_object_ = nrbmak(control_pnt, knot_vectors{1});
            elseif this.geometry_dimension_ == 2
                control_pnt = zeros(4,this.basis_number_(1), this.basis_number_(2));   
                for j = 1:this.basis_number_(2)
                    for i = 1:this.basis_number_(1)
                        n = (j-1)*this.basis_number_(1)+i;
                        disp(n)
                        control_pnt(:,i,j) = control_point_list(n,:)';
                        % multiply by weighting
                        control_pnt(1:end-1,i,j) = control_pnt(1:end-1,i,j)*control_pnt(end,i,j);
                    end
                end
                this.nurbs_tool_object_ = nrbmak(control_pnt, knot_vectors);
            elseif this.geometry_dimension_ == 3
                disp('Currently not support nurbs solid!');
            end

        end
        
        function plotNurbs(this, number_points)
            nrbplot(this.nurbs_tool_object_, number_points); 
        end
        
        function dispControlPoints(this)
            disp('(id) coordinates');
            if this.geometry_dimension_ == 1
                for i = 1:this.basis_number_(1)
                    str = ['(',num2str(i),') ',num2str(this.control_points_(i,:))];
                    disp(str);
                end
            elseif this.geometry_dimension_ == 2
                for j = 1:this.basis_number_(2)
                    for i = 1:this.basis_number_(1)
                        n = (j-1)*this.basis_number_(1)+i;
                        str = ['(',num2str(i),', ',num2str(j),') ',num2str(this.control_points_(n,:))];
                        disp(str);
                    end
                end
            elseif this.geometry_dimension_ == 3
                disp('Currently not support nurbs solid!');
            end
        end
        
    end
    
end

