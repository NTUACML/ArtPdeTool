classdef FEM_Domain < Domain.DomainBase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = FEM_Domain()
            this@Domain.DomainBase('FEM');
        end
        
        function basis = generateBasis(this, geometry, varargin)
            if(isa(geometry, 'Geometry.Geometry'))
                disp('FEM basis')
                basis = [];
            else
                disp('Error <FEM Domain>! check geometry input type!');
                disp('> empty basis builded!');
                basis = [];
            end
        end
        
        function variable = generateVariable(this, name, num_dof, basis, varargin);
            if(1)
            %if(isa(basis, ' '))
                disp('FEM basis')
                variable = [];
            else
                disp('Error <FEM Domain>! check basis input type!');
                disp('> empty variable builded!');
                basis = [];
            end
        end
    end
    
end

