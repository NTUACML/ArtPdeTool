classdef IntegrationRuleBuilderClass < handle
    %INTEGRATIONRULEBUILDERCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_	% integration rule type
        data_	% integration rule data
        status_	% integration rule builder status
    end
    
    methods
        % constructor
        function this = IntegrationRuleBuilderClass(type)
            this.type_ = type;
            this.status_ = logical(true);
        end
        
        % generate data
        function generateData(this, integral_source, varargin)
            % switching integration rule type
            switch this.type_
                case 'Mesh'
                    this.status_ = generateMeshTypeIntegrationRuleData...
                                                   (this, integral_source);
                    if(this.status_ == logical(true) )
                        this.status_ = this.data_.generate();
                    end
                case 'ScatterPoint' % TODO
                    this.status_ = logical(false);
                case 'NURBS' % TODO KAVY
                    this.status_ = logical(false);
                otherwise
                    disp('Error! check integration rule input type!');
                    this.status_ = logical(false);
            end
        end
        
        % get domain data
        function [integration_rule_data] = getIntegrationRuleData(this)
            integration_rule_data = this.data_;
        end
    end
    
    methods (Access = private)
        function status = generateMeshTypeIntegrationRuleData(this, integral_source)
            % Isoparamtric Element
            if(isa(integral_source, 'MeshDomainClass'))
                this.data_ = MeshIsoparametricIntegrationRuleClass(integral_source);
                
                status = logical(true);
            % Special integral domain
            elseif(ischar(integral_source))
                disp('Error (IntegrationRuleBuilder)!')
                disp('>> User define integration rule not supported!')
                
                status = logical(false);
            else
                disp('Error (IntegrationRuleBuilder)!')
                disp('>> check integration rule inputed integral source type!')
                
                status = logical(false);
            end
        end
    end
end

