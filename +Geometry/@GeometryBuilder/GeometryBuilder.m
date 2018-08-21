classdef GeometryBuilder
    %GEOMETRYBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function geometry = create(type, name, varargin)
            switch type
                case 'FEM'
                    switch name
                        case 'UnitCube'
                            geometry = Geometry.GeometryBuilder.FEM_UnitCube([]);
                        otherwise
                            disp('Warning <GeometryBuilder>!');
                            disp('> name in FEM type was not exist!');
                            disp('> empty geometry builded!');
                            geometry = []; 
                    end
                case 'EFG'
                    disp('Warning <GeometryBuilder>! EFG type not support yet!');
                    disp('> empty geometry builded!');
                    geometry = [];
                case 'RKPM'
                    disp('Warning <GeometryBuilder>! RKPM type not support yet!');
                    disp('> empty geometry builded!');
                    geometry = [];
                case 'IGA'
                    disp('Warning <GeometryBuilder>! IGA type not support yet!');
                    disp('> empty geometry builded!');
                    geometry = [];
                otherwise  
                	disp('Error <GeometryBuilder>! check domain input type!');
                    disp('> empty geometry builded!');
                	geometry = [];
            end
        end
    end
    
    
    methods(Static, Access = private)
        geometry = FEM_UnitCube(this, var);
    end
end

