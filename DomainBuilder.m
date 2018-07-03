function [ domain ] = DomainBuilder( type )
%DOMAINBUILDER Summary of this function goes here
%   Domain is used to describe the problem domain
switch type
    case 'Mesh'
        domain = UnitCube;
%         domain = StraightLine;
        domain.type = type;
        domain.status = 1;
    case 'ScatterPoint' % TODO
    case 'NURBS' % TODO KAVY
    otherwise
        disp('Error! Check type.');
        domain.status = 0;
        return;
end

end

function [ domain ] = UnitCube
%UNITCUBE Summary of this function goes here
domain.node = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
domain.connectivity = [1 2 3 4 5 6 7 8];
domain.element_number = 1;
domain.node_number = 8;
domain.dim = 3;
domain.is_isoparametric = 1;
domain.element_name = 'Hexa8';

domain.boundary_connectivity = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7;1 4 8 5];

end

function [ domain ] = StraightLine
%StraightLine Summary of this function goes here
num_element = 10;
domain.node = linspace(0, 1, num_element + 1)';
domain.connectivity = [(1:num_element)', (2:num_element+1)'];
domain.element_number = num_element;
domain.node_number = length(domain.node);
domain.dim = 1;
domain.is_isoparametric = 1;
domain.element_name = 'Line2';

domain.boundary_connectivity = [1; domain.node_number];

end

