function [ variable ] = Variable( name, dim, varargin )
%VARIABLE Summary of this function goes here
%   Detailed explanation goes here
variable.name = name;
variable.dim = dim;

if(isempty(varargin))
    data = [];
    variable.data = data;
    variable.data_number = 0;
    variable.data_component = @ (component_dim) data;
else
    data = zeros(variable.dim * varargin{1}, 1);
    variable.data = data;
    variable.data_number = size(variable.data, 1);
    variable.data_component= @ (component_dim) data_component(component_dim, variable.data, variable.dim); 
end

end

function data_out = data_component(component_dim, data, dim)
data_number = size(data,1);
data_out = data(component_dim:dim:data_number);
end