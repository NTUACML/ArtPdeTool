classdef DomainBuilderClass < handle
    %DOMAINBUILDERCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_      % domain type
        name_      % domain name
        data_      % domain real data
        status_    % domain status (1: domain data generated; 0: none)
    end
    
    methods
        % constructor
        function this = DomainBuilderClass(type)
            this.type_ = type;
            this.status_ = logical(false);
            % switching domain type and constructing each domain data class
            switch type
                case 'Mesh'
                    this.data_ = MeshDomainDataClass();
                case 'ScatterPoint' % TODO
                case 'NURBS' % TODO KAVY
                otherwise
                    disp('Error! Check type!');
            end
        end
        
        % generate data
        function generateData(this, name)
            this.status_ = this.data_.generate(name);
        end
        
        % get domain data
        function [domain_data] = getDomainData(this)
            domain_data = this.data_;
        end
        
    end
    
end

