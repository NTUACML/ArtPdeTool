classdef Variable < handle
    %VARIABLE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        name_           % variable name
        num_dof_ = 0    % variable degree of freedom
        num_data_ = 0   % total variable data number
        dof_data_       % variable data stored in each dof cell space
    end
    
    methods
        % constructor
        function this = Variable(name, num_dof)
            % fundamental variable data
            this.name_ = name;
            this.num_dof_ = num_dof;
            this.dof_data_ = cell(this.num_dof_, 1);
        end
        
        % function to obtaine data component
        function data = getDofData(this, num_component)
            if(num_component <= this.num_dof_)
                data = this.dof_data_{num_component};
            else
                disp('Error <Variable>! check number of component!');
                disp('> the num_component should smaller than num_dof!');
            end
        end
        
        function disp(this)
            disp(['The variale name is: ', this.name_])
            disp(['The number of dof: ', num2str(this.num_dof_)])
            if(this.num_data_ == 0)
                disp('Data are empty!')
            else
                disp('Data are: ')
                temp_data = zeros(this.num_data_, this.num_dof_);
                for i = 1 : this.num_dof_
                    temp_data(:, i) = this.dof_data_{i};
                end
                disp(temp_data);
            end
        end
    end
    

end

