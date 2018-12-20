classdef Nurbs < handle    
    properties   
        knot_vectors_
        order_
        basis_number_
        type_
        control_points_
    end
    
    properties(Access = private)
%         nurbs_tool_object_ = [];
        geometry_dimension_
    end
    
    methods
        function this = Nurbs(knot_vectors, order, control_point_list)
            this.knot_vectors_ = knot_vectors;
            this.order_ = order;
            
            import Utility.NurbsUtility.NurbsType
            this.geometry_dimension_ = length(knot_vectors);
            if this.geometry_dimension_ == 1
                this.type_ = NurbsType.Curve;
            elseif this.geometry_dimension_ == 2
                this.type_ = NurbsType.Surface;
            elseif this.geometry_dimension_ == 3
                this.type_ = NurbsType.Solid;
            end
            
            this.basis_number_ = zeros(1, this.geometry_dimension_);
            for i = 1:this.geometry_dimension_
                this.basis_number_(i) = length(knot_vectors{i})-order(i)-1;
            end
            
            import Utility.BasicUtility.PointList
            this.control_points_ = control_point_list;
        end
        
        function dim = getGeometryDimension(this)
            dim = this.geometry_dimension_;
        end
      
        function dispControlPoints(this)
            import Utility.BasicUtility.TensorProduct
            disp('Id       Coordinates');
            if this.geometry_dimension_ == 1
                TD_1 = TensorProduct({this.basis_number_(1)});
                for i = 1:TD_1.total_num_
                    local_id = TD_1.to_local_index(i);
                    str = '(%3d)%10.3f%10.3f%10.3f%10.3f\n';
                    fprintf(str, local_id{1}, local_id{2}, this.control_points_(i,:));
                end
            elseif this.geometry_dimension_ == 2
                TD_2 = TensorProduct({this.basis_number_(1) this.basis_number_(2)});
                for i = 1:TD_2.total_num_
                    local_id = TD_2.to_local_index(i);
                    str = '(%3d,%3d)%10.3f%10.3f%10.3f%10.3f\n';
                    fprintf(str, local_id{1}, local_id{2}, this.control_points_(i,:));
                end
            elseif this.geometry_dimension_ == 3
                TD_3 = TensorProduct({this.basis_number_(1) this.basis_number_(2) this.basis_number_(3)});
                for i = 1:TD_3.total_num_
                    local_id = TD_3.to_local_index(i);
                    str = '(%3d,%3d,%3d)%10.3f%10.3f%10.3f%10.3f\n';
                    fprintf(str, local_id{1}, local_id{2}, local_id{3}, this.control_points_(i,:));
                end
            end
        end
        
        function dispKnotVectors(this)
            disp('Knot vectors');
            for i = 1:this.geometry_dimension_
                str = ['[', num2str(this.knot_vectors_{i}, '%6.2f'), ']'];
                disp(str);
            end
        end
    end
end

