classdef ConstraintBuilder
    %CONSTRAINTBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function constraint = create(type)
            switch type
                case 'FEM'
                    constraint = Constraint.FEM.Constraint();
                case 'EFG'
                    disp('Warning <ConstraintBuilder>! EFG type not support yet!');
                    disp('> empty geometry builded!');
                    constraint = [];
                case 'RKPM'
                    disp('Warning <ConstraintBuilder>! RKPM type not support yet!');
                    disp('> empty geometry builded!');
                    constraint = [];
                case 'IGA'
                    disp('Warning <ConstraintBuilder>! IGA type not support yet!');
                    disp('> empty geometry builded!');
                    constraint = [];
                otherwise  
                	disp('Error <ConstraintBuilder>! Constraint domain input type!');
                    disp('> empty Constraint builded!');
                	constraint = [];
            end
        end
    end
    
end

