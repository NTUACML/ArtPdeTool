function [ varargout ] = DofManager( varargin )
%DOFMANAGER Summary of this function goes here
% varargin = {variable_1, function_space_1, variable_2, function_space_2, ...}
% varargout = {dof_manager, variable_1, variable_2, ...}

% Total variable number
dof_manager.variable_number = nargin/2;

% Total variable name table
dof_manager.variable_table = cell(1, dof_manager.variable_number);
for i = 1:dof_manager.variable_number
    dof_manager.variable_table{i} = varargin{2*i-1}.name_;
end

% Initialize variable data if they are not initialized elsewhere
variable_dof_number = zeros(1, dof_manager.variable_number);
for i = 1:dof_manager.variable_number
    if isempty(varargin{2*i-1}.data_)
        varargin{2*i-1}.data_ = zeros(varargin{2*i-1}.dim_ * varargin{2*i}.basis_number, 1);
        varargin{2*i-1}.data_number_ = size(varargin{2*i-1}.data_, 1);
    end
    
    variable_dof_number(i) = varargin{2*i-1}.data_number_;
end

% Total dof number
dof_manager.total_dof_number = sum(variable_dof_number);

% Get variable sequence
dof_manager.variable_sequence = @ (variable) VariableSequence(variable.name_, dof_manager.variable_table);

% Map non_zero_basis_id of some variable to their global id in dof_manager
dof_manager.global_id = @ (non_zero_basis_id, variable) GlobalId(non_zero_basis_id, variable.dim_) + ... 
                                            sum(variable_dof_number(1:dof_manager.variable_sequence(variable)-1));

% Get variable data
dof_manager.get_variable_data = @ (variable) varargin{2*dof_manager.variable_sequence(variable)-1}.data_;
                                    


% Output data
varargout = cell(1, 1+dof_manager.variable_number);
varargout{1} = dof_manager;
for i = 1:dof_manager.variable_number
    varargout{i+1} = varargin{2*i-1};
end

end

function global_id = GlobalId(non_zero_basis_id, dim)

id_number = length(non_zero_basis_id);

global_id = zeros(1, id_number*dim);

temp = 1:dim;

for i = 1:id_number
    global_id((i-1)*dim+temp) = (non_zero_basis_id(i)-1)*dim + temp;
end

end

function variable_sequence = VariableSequence(name, table)
    for i = 1:size(table,2)
        if strcmp(name, table{i})
            variable_sequence = i;
            return;
        end
    end
end

function data = VariableData(variable_name, dim)
    
end