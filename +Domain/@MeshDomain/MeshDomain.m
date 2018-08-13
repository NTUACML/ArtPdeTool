classdef MeshDomain < Domain.DomainData.DomainData
    %MESHDOMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name_ = 'None'       % mesh name
    end
    
    methods
        function this = MeshDomain()
            this = this@Domain.DomainData.DomainData();
            disp('Domain <Mesh> : created!')
        end
        
        function name = getName(this)
            name = this.name_;
        end

        function disp(this)
            disp('> The mesh type basic info: ')
            disp(['Mesh name: ', this.name_])
            disp@Domain.DomainData.DomainData(this)
            disp('> The mesh type interior unit info: ')
            for i = 1 : this.num_interior_
                disp(['>> Interoir: ', num2str(i)])
                disp(this.interior_data_{i})
            end
            disp('> The mesh type boundary unit info: ')
            for i = 1 : this.num_boundary_
                disp(['>> Boundary: ', num2str(i)])
                disp(this.boundary_data_{i})
            end
        end
    end
    
    methods(Access = {?Domain.DomainBuilder})
        function generate(this, name)
            switch name
                case 'UnitCube'
                    this.name_ = 'UnitCube';
                    UnitCube(this);
                case 'UnitSquare'
                    this.name_ = 'UnitSquare';
                    UnitSquare(this);
                case 'StraightLine'
                    this.name_ = 'StraightLine';
                    StraightLine(this);
                otherwise
                    disp('Error<MeshDomain> ! Check mesh input name!');
            end

        end
    end
    
end

