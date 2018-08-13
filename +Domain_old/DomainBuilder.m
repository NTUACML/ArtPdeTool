classdef DomainBuilder
    %DOMAINBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        % real domain creating function
        function domain = create(type, varargin)
            switch type
                case 'Mesh'
                    import Domain.MeshDomain
                    if(isempty(varargin))
                        domain = MeshDomain();
                        disp('Warning <DomainBuilder>! empty mesh domian builded!');
                        disp('> empty mesh domian builded!');
                    else
                        domain = MeshDomain();
                        domain.generate(varargin{1}) % varargin{1} is mesh name.
                    end
                case 'ScatterPoint' 
                    import Domain.PointDomain
                    if(isempty(varargin))
                        domain = PointDomain();
                        disp('Warning <DomainBuilder>! empty scatter point domian builded!');
                        disp('> empty scatter point domian builded!');
                    else
                        domain = PointDomain();
                        domain.generate(varargin{1}) % varargin{1} is point domain name.
                    end
                case 'NURBS' % TODO KAVY
                    disp('Error <DomainBuilder>! NURBS type not support yet!');
                    domain = [];
                otherwise  
                    disp('Error <DomainBuilder>! check domain input type!'); 
                    domain = [];
            end
        end
    end
    
end

