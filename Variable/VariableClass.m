classdef VariableClass < handle
    %VARIABLECLASS Summary of this class goes here
    %   Detailed explanation goes here
    properties
        name_           % variable name
        num_data_       % total variable data number
        data_           % variable data
        variable_dof_   % variable degree of freedom
    end
    
    methods
        % constructor
        function this = VariableClass(name, variable_dof, varargin)
            % fundamental variable data
            this.name_ = name;
            this.variable_dof_ = variable_dof;
            this.data_ = [];
            this.num_data_ = 0;
            
            % data initialized from Varargin
            if ~isempty(varargin)
                % initialized selecter with first paramater.
                if(isa(varargin{1}, 'FunctionSpaceClass'))
                    % for case : FunctionSpaceClass
                    this.initByFunctionSpace(varargin{1});
                elseif(isnumeric(varargin{1}))
                    % for case : number (interger)
                    this.initByInteger(varargin{1});
                else
                    disp('Error (VariableClass) : initialized parameter input error!');
                    disp('>> the FunctionSpaceClass and interger is supported!');
                end
            end
            
            % show info
            this.initShowDetail();
        end
        
        % function to obtaine data component
        function data_out = data_component(this, component_dof)
            data_out = this.data_(component_dof:this.variable_dof_:this.num_data_);
        end
    end
    
    methods (Access = private)
        function initByFunctionSpace(this, function_space)
            this.num_data_ = this.variable_dof_ * function_space.num_basis_;
            this.data_ = zeros(this.num_data_, 1);
        end
        
        function initByInteger(this, int_number)
            this.num_data_ = this.variable_dof_ * int_number;
            this.data_ = zeros(this.num_data_, 1);
        end
        
        function initShowDetail(this)
            disp(['Variable <', this.name_, '> : created!']);
            if(this.variable_dof_ == 1)
                disp('>> Scalar variable initialized')
            else
                disp(['>> Vector variable initialized with DOF = ', num2str(this.variable_dof_)])
            end
        end
    end
end

