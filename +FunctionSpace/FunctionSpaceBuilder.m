classdef FunctionSpaceBuilder
    %FUNCTIONSPACEBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        % real domain creating function
        function function_space = create(type, domain, varargin)
            switch type
                case 'FEM'
                    if(isa(domain, 'Domain.MeshDomain'))
                        import FunctionSpace.FEM_FunctionSpace
                        % create FEM function space
                        function_space = FEM_FunctionSpace(domain);
                        % generate function space data by inputting varargin{1}
                        if(isempty(varargin))
                            function_space.generate();
                        else
                            function_space.generate(varargin{1});
                        end
                    else
                        disp('Error <FunctionSpaceBuilder>! check function space domain type!'); 
                        function_space = []; 
                    end
                case 'RKPM' 
                    if(isa(domain, 'Domain.PointDomain'))
                        import FunctionSpace.RKPM_FunctionSpace
                        % create RKPM function space
                        function_space = RKPM_FunctionSpace(domain);
                        % generate function space data by inputting
                        % order: varargin{1} & support_size_ratio: varargin{2}
                        if(isempty(varargin))
                            function_space.generate();
                        else
                            function_space.generate(varargin{1}, varargin{2});
                        end
                    else
                        disp('Error <FunctionSpaceBuilder>! check function space domain type!'); 
                        function_space = []; 
                    end
                otherwise  
                    disp('Error <FunctionSpaceBuilder>! check function space input type!'); 
                    function_space = [];  
            end
        end
    end
    
end

