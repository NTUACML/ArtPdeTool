classdef FunctionSpaceBuilderClass  < handle
    %FUNCTIONSPACEBUILDERCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_     % problem domain
        data_       % function space real data
        status_     % function space builder status
    end
    
    methods
        % constructor
        function this = FunctionSpaceBuilderClass(domain)
            this.domain_ = domain;
            this.status_ = logical(true);
        end
        
        % generate data
        function generateData(this, varargin) % here can add parametr e.g.: 'order'...
               generateFunctionSpaceDataByDomain(this);
               if(this.status_ == logical(true) )
                    this.status_ = this.data_.generate(varargin);
               end
        end
        
        % get function space data
        function [function_space_data] = getFunctionSpaceData(this)
            function_space_data = this.data_;
        end
    end
    
    methods (Access = private)
        function generateFunctionSpaceDataByDomain(this)
            % switch domain type initialization
            if(isa(this.domain_, 'MeshDomainClass')) % Mesh type domain
                this.data_ = MeshFunctionSpaceClass(this.domain_);
                this.status_ = logical(true);
            else
                disp('Error! FunctionSpace input doamin type error!');
                this.status_ = logical(false);
            end
        end  
    end
    
end

