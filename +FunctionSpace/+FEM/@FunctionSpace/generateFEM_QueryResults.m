function generateFEM_QueryResults(this)
%GENERATEINTERIORFEM_QUERYRESULTS Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.PatchType
    import Utility.MeshUtility.ElementType
    import FunctionSpace.FEM.ShapeFunction
    if(this.type_ == PatchType.Mesh)
        num_element = this.patch_data_.num_element_;
        num_query_data = 2;
        % 1. non_zero_id
        % 2. evaluate_basis
        this.fem_query_results_ = cell(num_element, num_query_data);
        
        for i = 1 : num_element
            element = this.patch_data_.element_data_{i};
            non_zero_id = element.node_id_;
            eval_sf = ...
                ShapeFunction.MappingElementType2ShapeFunction( element.element_type_ );
            % 1. non_zero_id
            this.fem_query_results_{i, 1} = non_zero_id;
            % 2. evaluate_basis
            this.fem_query_results_{i, 2} = eval_sf;
        end
    elseif(this.type_ == PatchType.Point)
        num_point = this.patch_data_.num_patch_point_;
        num_query_data = 2;
        % 1. non_zero_id
        % 2. evaluate_basis
        this.fem_query_results_ = cell(num_point, num_query_data);
        
        for i = 1 : num_point
            non_zero_id = this.patch_data_.patch_point_id_(i);
            eval_sf = ...
                ShapeFunction.MappingElementType2ShapeFunction( ElementType.Point1 );
            % 1. non_zero_id
            this.fem_query_results_{i, 1} = non_zero_id;
            % 2. evaluate_basis
            this.fem_query_results_{i, 2} = eval_sf;
        end
    else
        disp('Error <FEM.FunctionSpace>! -> generateFEM_QueryResults');
        disp('> PatchType error!');
    end
end

