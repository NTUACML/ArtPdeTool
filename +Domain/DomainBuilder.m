classdef DomainBuilder
    %DomainBuilder Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function domain = create(type)
            switch type
                case 'FEM'
                    domain = Domain.FEM.Domain();
                case 'EFG'
                    disp('Warning <DomainBuilder>! EFG type not support yet!');
                    disp('> empty geometry builded!');
                    domain = [];
                case 'RKPM'
                    disp('Warning <DomainBuilder>! RKPM type not support yet!');
                    disp('> empty geometry builded!');
                    domain = [];
                case 'IGA'
                    disp('Warning <DomainBuilder>! IGA type not support yet!');
                    disp('> empty geometry builded!');
                    domain = [];
                otherwise  
                	disp('Error <DomainBuilder>! check domain input type!');
                    disp('> empty geometry builded!');
                	domain = [];
            end
        end
    end
    
end

