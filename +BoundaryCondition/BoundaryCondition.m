classdef BoundaryCondition < handle
    %BOUNDARYCONDITIONBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        variable_
        bc_patch_name_
        bc_setting_
    end
    
    methods
        function this = BoundaryCondition(bc_patch_name, variable)
            import Utility.BasicUtility.BC_Type
            this.bc_patch_name_ = bc_patch_name;
            if(isa(variable, 'Variable.Variable'))
                this.variable_ = variable;
                this.setAllDefaultType(this.variable_.num_dof_, BC_Type.Neumann);
            else
                disp('Error <BoundaryCondition>! check variable type!');
                disp('> The variable should be defined by Variable class!');
            end
        end
        
        function setDirichlet(this, value, varargin)
            import Utility.BasicUtility.BC_Type
            num_dof = this.variable_.num_dof_;
            all_dof_id = (1 : num_dof);
            
            parser = inputParser;
            addRequired(parser,'value');
            addParameter(parser,'component', all_dof_id);
            parse(parser,value, varargin{:});
            if(length(parser.Results.component) == length(parser.Results.value))
                for i = 1 : length(parser.Results.component)
                    id = parser.Results.component(i);
                    this.bc_setting_{id, 1} = BC_Type.Dirichlet;
                    this.bc_setting_{id, 2} = parser.Results.value{i};
                end
            else
                disp('Error <BoundaryCondition> -> setDirichlet!');
                disp('> value and component length should be same as each other!');
            end
                
        end
        
        function setNeumann(this, value, varargin)
            import Utility.BasicUtility.BC_Type
            num_dof = this.variable_.num_dof_;
            all_dof_id = (1 : num_dof);
            
            parser = inputParser;
            addRequired(parser,'value');
            addParameter(parser,'component', all_dof_id);
            parse(parser,value, varargin{:});
            if(length(parser.Results.component) == length(parser.Results.value))
                for i = 1 : length(parser.Results.component)
                    id = parser.Results.component(i);
                    this.bc_setting_{id, 1} = BC_Type.Neumann;
                    this.bc_setting_{id, 2} = parser.Results.value{i};
                end
            else
                disp('Error <BoundaryCondition> -> setNeumann!');
                disp('> value and component length should be same as each other!');
            end    
        end
        
        function setEssential(this, value)
            import Utility.BasicUtility.BC_Type
            num_dof = this.variable_.num_dof_;
            this.setAllDefaultType(num_dof, BC_Type.Essential);
            if(length(value) == num_dof)
                for i = 1 : num_dof
                    this.bc_setting_{i, 2} = value{i};
                end
            else
                disp('Error <BoundaryCondition> -> setEssential!');
                disp('> The value should set the same number of DOF!');
            end
        end
        
        function setNatural(this, value)
            import Utility.BasicUtility.BC_Type
            num_dof = this.variable_.num_dof_;
            this.setAllDefaultType(num_dof, BC_Type.Natural);
            if(length(value) == 1)
                for i = 1 : num_dof
                    this.bc_setting_{i, 2} = value{1};
                end
            else
                disp('Error <BoundaryCondition> -> setNatural!');
                disp('> The natural (traction) boundary condition only one control value');
            end
        end
        
        function disp(this)
            disp(['The ', this.bc_patch_name_ ,' boundary condition for ', this.variable_.name_])
            disp(['with ', num2str(this.variable_.num_dof_), ' DOF is:'])
            disp(this.bc_setting_)
        end
        
    end
    
    methods (Access = private)
        function setAllDefaultType(this, num_dof, type)
            import Utility.BasicUtility.BC_Type
            num_data = 2;
            % Data for bc setting (each dof)
            % > 1. Numerical type
            % > 2. Type value
            this.bc_setting_ = cell(num_dof, num_data);
            % put default value
            for i = 1 : num_dof
                this.bc_setting_{i, 1} = type;
                this.bc_setting_{i, 2} = 0;
            end
        end

    end
end

