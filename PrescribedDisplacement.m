function [ prescribed_bc ] = PrescribedDisplacement( prescribed_bc_, node_id, direction, value )
%PRESCRIBEDDISPLACEMENT Summary of this function goes here
%   Detailed explanation goes here
if isempty(prescribed_bc_)
    prescribed_bc.node_id = node_id;
    prescribed_bc.direction = direction;
    prescribed_bc.value = value;
else
    prescribed_bc.node_id = [prescribed_bc_.node_id, node_id];
    prescribed_bc.direction = [prescribed_bc_.direction, direction];
    prescribed_bc.value = [prescribed_bc_.value, value];
end

end

