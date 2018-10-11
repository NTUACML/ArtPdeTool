function results = queryFEM_shapefunction( this, query_unit, query_parameter )
%QUERYFEM_SHAPEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

    % check query unit type
    if(isa(query_unit, 'BasisFunction.FEM.QueryUnit'))
        import Utility.BasicUtility.Region
    	% query region varified
        if(query_unit.query_protocol_{1} == Region.Domain)
            % query shape function
            query_id = query_unit.query_protocol_{2};
            %> query - non_zero_id
            query_unit.non_zero_id_ = this.FEM_shapefunction_{query_id, 1};
            %> query - evaluate_basis_
            query_unit.evaluate_basis_ = this.FEM_shapefunction_{query_id, 2};
            % check
            results = true;
        else
            results = false;
            disp('Error <BasisFunction>! - queryFEM_shapefunction!');
            disp('> Query protocol error!');
            disp('> The basis function can only query in the domain region.');
            disp('> Please excuting the decode procedue transfer the boundary into the domain protocol.');
        end
        
    else
    	results = false;
        disp('Error <BasisFunction>! - queryFEM_shapefunction!');
        disp('> Please check the query_unit is type of FEM query_unit');
    end


end

