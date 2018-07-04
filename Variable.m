function [ variable ] = Variable( name, dim, varargin )
%VARIABLE Summary of this function goes here
%   Detailed explanation goes here
variable.name = name;
variable.dim = dim;
variable.resetValue = @(N) zeros(N, 1);

if(isempty(varargin))
	variable.value = 0;
else
    variable.value = variable.resetValue(variable.dim * varargin{1});
end

end

