classdef FunctionSpace < FunctionSpace.FunctionSpaceBase
    %FUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        type_
        region_
    end
    properties (Access = private)
        fem_query_results_
    end
    
    methods
        function this = FunctionSpace(patch)
            this@FunctionSpace.FunctionSpaceBase(patch)
            this.region_ = patch.patch_region_;
            this.type_ = patch.patch_type_;
            import Utility.BasicUtility.Region
            if(this.region_ == Region.Interior)
                this.generateInteriorFEM_QueryResults();
            else
                % Todo: gen_boundary
            end
            
        end
        
        function query(this, query_unit, varargin)
            if(isa(query_unit, 'FunctionSpace.FEM.QueryUnit'))
                this.queryFEM_FunctionSpace(query_unit);
            else
                disp('Error <FEM.FunctionSpace>! query type error!');
                disp('> query function space should be a quary_unit!');
            end
        end
    end
    
    methods (Access = private)
        generateInteriorFEM_QueryResults(this)
        queryFEM_FunctionSpace(this, query_unit)
    end
end

