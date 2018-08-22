function generateInteriorFEM_QueryResults(this)
%GENERATEINTERIORFEM_QUERYRESULTS Summary of this function goes here
%   Detailed explanation goes here
    import Utility.BasicUtility.PatchType
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
        
    else
        disp('Error <FEM.FunctionSpace>! (Interior)');
        disp('> PatchType error!');
    end
end

