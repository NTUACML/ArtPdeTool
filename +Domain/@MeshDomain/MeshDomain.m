classdef MeshDomain < handle
    %MESHDOMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name_ = 'None'       % mesh name
        interior_            % mesh interior domain data
        boundary_            % mesh boundary domain data
    end
    
    methods
        function this = MeshDomain()
            import Domain.MeshDomainUnit.MeshInteriorDomainUnit
            import Domain.MeshDomainUnit.MeshBoundaryDomainUnit
            this.interior_ = MeshInteriorDomainUnit();
            this.boundary_ = MeshBoundaryDomainUnit();
            disp('Domain <Mesh> : created!')
        end
        
        function name = getName(this)
            name = this.name_;
        end
        
        function interior_domain = getInterior(this)
            interior_domain = this.interior_;
        end
        
        function boundary_domain = getBoundary(this)
            boundary_domain = this.boundary_;
        end
        
        function disp(this)
            disp('The mesh type domain info: ')
            disp(['Mesh name: ', this.name_])
            disp(this.interior_);
            disp(this.boundary_);
        end
    end
    
    methods(Access = {?Domain.DomainBuilder})
        function generate(this, name)
            switch name
                case 'UnitCube'
                    this.name_ = 'UnitCube';
                    UnitCube(this);
                case 'StraightLine'
                    this.name_ = 'StraightLine';
%                     StraightLine(this);
                otherwise
                    disp('Error<MeshDomain> ! Check mesh input name!');
            end
            this.interior_.NumberUpdate();
            this.boundary_.NumberUpdate();
        end
    end
    
    methods(Access = private)
        UnitCube(this);
%         StraightLine(this);
    end
    
end

