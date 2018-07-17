classdef DomainBuilderClass < handle
    %DOMAINBUILDERCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_	% domain type
        data_	% domain real data
        status_	% domain status
    end
    
    methods
        % constructor
        function this = DomainBuilderClass(type)
            this.type_ = type;
            this.status_ = logical(true);
        end
        
        % generate data
        function generateData(this, name, varargin)
               this.status_ = generateDomainDataByType(this);
               if(this.status_ == logical(true) )
                    this.status_ = this.data_.generate(name);
               end
        end
        
        % get domain data
        function [domain_data] = getDomainData(this)
            domain_data = this.data_;
        end
        
    end
    
    methods (Access = private)
        function status = generateDomainDataByType(this)
            % switching domain type and constructing each domain data class
            switch this.type_
                case 'Mesh'
                    this.data_ = MeshDomainClass();
                    status = logical(true);
                case 'ScatterPoint' 
                    this.data_ = PointDomainClass();
                    status = logical(true);
                case 'NURBS' % TODO KAVY
                    status = logical(false);
                otherwise
                    disp('Error (DomainBuilder)! check domain input type!');
                    status = logical(false);
            end
        end 
    end
    
end

