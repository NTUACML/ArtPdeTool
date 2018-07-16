classdef DofManagerClass
    %DOFMANAGERCLASS Summary of this class goes here
    % varargin = {variable_1, function_space_1, variable_2, function_space_2, ...}
    
    properties
        variable_number_        % total variable number of this dof_manager
        variable_table_         % variable table consists of variable names
        total_dof_number_       % total number of dof
        variable_data_number_   % number of data for each variable
    end
    
    methods
        function this = DofManagerClass(varargin)
            this.variable_number_ = nargin/2;
            
            this.variable_table_ = cell(1, this.variable_number_);
            for i = 1:this.variable_number_
                this.variable_table_{i} = varargin{2*i-1}.name_;
            end   
            
            this.variable_data_number_ = zeros(1, this.variable_number_);
            for i = 1:this.variable_number_
                if isempty(varargin{2*i-1}.data_)
                    this.variable_data_number_(i) = varargin{2*i-1}.dim_ * varargin{2*i}.num_basis_;
                else
                    this.variable_data_number_(i) = varargin{2*i-1}.data_number_; 
                end
            end
            
            % Total dof number
            this.total_dof_number_ = sum(this.variable_data_number_);   
        end
        
        % Initialize variable data if they are not initialized elsewhere
        function varargout = initialize_variables(this, varargin)
            % varargin = {variable_1, variable_2, ...}
            % varargout = {variable_1, variable_2, ...}
            for i = 1:this.variable_number_
                if isempty(varargin{i}.data_)
                    varargin{i}.data_ = zeros(this.variable_data_number_(i), 1);
                    varargin{i}.data_number_ = size(varargin{i}.data_, 1);
                end
            end
            
            varargout = varargin;
        end
        
        % Get variable sequence  
        function value = variable_sequence(this, variable)
            for i = 1:size(this.variable_table_, 2)
                if strcmp(variable.name_, this.variable_table_{i})
                    value = i;
                    return;
                end
            end            
        end
        
        % Map non_zero_basis_id of some variable to their global id in dof_manager
        function value = global_id(this, non_zero_basis_id, variable)
            value = GlobalId(non_zero_basis_id, variable.dim_) + ...
                sum(this.variable_data_number_(1:this.variable_sequence(variable)-1));
            
        end
        % Get variable data  
        function value = get_variable_data(~, variable, component_dim)
            value = variable.data_component(component_dim);
        end
        
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

