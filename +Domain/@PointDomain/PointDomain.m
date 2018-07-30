classdef PointDomain < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name_ = 'None'       % domain name
        interior_            % point interior domain data
        boundary_            % point boundary domain data
    end
    
    methods
        function this = PointDomain()
            import Domain.PointDomainUnit.PointInteriorDomainUnit
            import Domain.PointDomainUnit.PointBoundaryDomainUnit
            this.interior_ = PointInteriorDomainUnit();
            this.boundary_ = PointBoundaryDomainUnit();
            disp('Domain <Scatter Point> : created!')
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
%                 case 'UnitCube'
%                     this.name_ = 'UnitCube';
%                     UnitCube(this);
                case 'StraightLine'
                    this.name_ = 'StraightLine';
                    StraightLine(this);
                case 'UnitSquare'
                    this.name_ = 'UnitSquare';
                    UnitSquare(this);
                otherwise
                    disp('Error<PointDomain> ! Check point domain input name!');
            end
            this.interior_.NumberUpdate();
            this.boundary_.NumberUpdate();
        end
    end
    
    methods(Access = private)
%         UnitCube(this);
        StraightLine(this);
        UnitSquare(this);
    end
        

    
end

