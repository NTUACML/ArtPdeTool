function [ dof_manager ] = DofManager( variable, function_space )
%DOFMANAGER Summary of this function goes here
%   Detailed explanation goes here

dof_manager.name = variable.name;
dof_manager.total_dof_number = function_space.basis_number * variable.dim;
dof_manager.global_id = @ (non_zero_basis_id) GlobalId(non_zero_basis_id, variable.dim); 


end

function global_id = GlobalId(non_zero_basis_id, dim)

id_number = length(non_zero_basis_id);

global_id = zeros(1, id_number*dim);

temp = 1:dim;

for i = 1:id_number
    global_id((i-1)*dim+temp) = (non_zero_basis_id(i)-1)*dim + temp;
end

end