function [ integration_rule ] = IntegrationRule( domain )
%INTEGRATIONRULE Summary of this function goes here
%   Detailed explanation goes here

switch domain.type
    case 'Mesh'
        integration_rule.is_isoparametric = domain.is_isoparametric;
        integration_rule.unit_number = domain.element_number;
        integration_rule.unit = cell(integration_rule.unit_number, 1);
        
        if integration_rule.is_isoparametric         
            if strcmp(domain.element_name, 'Hexa8')
                xg = [-0.57735026918963D0, 0.57735026918963D0];
                w = [1.00000000000000D0, 1.00000000000000D0];
                unit.position = zeros(8, 3);
                unit.weighting = zeros(8, 1);
                unit.point_number = 8;
                for i = 1:2,
                    for j = 1:2,
                        for k = 1:2
                            unit.position(4*(i-1)+2*(j-1)+k, :) = [xg(i) xg(j) xg(k)];
                            unit.weighting(4*(i-1)+2*(j-1)+k) = w(i)*w(j)*w(k);
                        end
                    end
                end
            elseif (strcmp(domain.element_name, 'Line2'))
                xg = [-0.57735026918963D0, 0.57735026918963D0];
                w = [1.00000000000000D0, 1.00000000000000D0];
                unit.position = xg';
                unit.weighting = w';
                unit.point_number = 2;
            end

            for i = 1:integration_rule.unit_number
                elm_node = domain.node(domain.connectivity, :);
                unit.Jacobian = @(d_shape_func) d_shape_func * elm_node;
                
                integration_rule.unit{i} = unit;
            end
        else
            % if not isoparametric, integration unit is generated from domain
            % information
            % TODO: generate integration unit for non-isoparametric
        end
    case 'ScatterPoint'
    case 'NURBS'
        
end







end

