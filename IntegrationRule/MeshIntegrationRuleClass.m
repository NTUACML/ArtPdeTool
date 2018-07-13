classdef MeshIntegrationRuleClass < IntegrationRuleClass
    %MESHINTEGRATIONRULECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domain_data_                      % domain data (mesh type)
        is_isoparamtric = logical(false)  % flag for isoparamtric element
                                          % (default: not isoparamtric)
    end
    
    methods
        % constructor
        function this = MeshIntegrationRuleClass()
            % Call base class constructor
            this = this@IntegrationRuleClass();
        end
        
        % !!!(virtual function)!!!
        % generate integration rule by sub-class definition.
        function status = generate(this, varargin)
            status = logical(true);
        end
        
        function [int_unit, evaluate_jacobian] = quarry(this, quarry_unit, varargin)
            int_unit = [];
            evaluate_jacobian = [];
        end
    end
    
    methods(Static)
        function [jacobian_matrix, jacobian_determinant] = evaluateJacobian(d_shape_func, node_data)
            jacobian_matrix = d_shape_func * node_data;
            jacobian_determinant = det(jacobian_matrix);
        end
    end
end

