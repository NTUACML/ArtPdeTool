classdef MeshTopology < Geometry.Topology.TopologyBase
    %MESHTOPOLOGY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = MeshTopology(dim)
            % import zone
            import Utility.MeshUtility.MeshPatch
            import Utility.BasicUtility.PatchType
            import Utility.BasicUtility.Region
            % Base class constructor
            this@Geometry.Topology.TopologyBase(dim);
            % New the domain patch data
            this.domain_patch_data_ = MeshPatch(...
                this.dim_, 'Domain', PatchType.Mesh, Region.Domain);
            % New the map table for the boundary patch
            this.boundary_patch_data_ = ...
                containers.Map(...
                'KeyType','char','ValueType','any');
        end
        
        function domain_patch = getDomainPatch(this)
            domain_patch = this.domain_patch_data_;
        end
        
        function boundary_patch = newBoundayPatch(this, patch_name)
            if(~isKey(this.boundary_patch_data_, patch_name))
                import Utility.MeshUtility.MeshPatch
                import Utility.BasicUtility.PatchType
                import Utility.BasicUtility.Region
                boundary_patch = MeshPatch(...
                    (this.dim_ - 1), patch_name, PatchType.Mesh, Region.Boundary);
                this.boundary_patch_data_(patch_name) = boundary_patch;
            else
                disp('Error <MeshTopology> - newBoundayPatch!');
                disp(['> You entered patch name: ''', patch_name, ''' existed']);
                disp('> Please check it again.');
            end
        end
        
        function boundary_patch = getBoundayPatch(this, patch_name)
            if(isKey(this.boundary_patch_data_, patch_name))
                boundary_patch = this.boundary_patch_data_(patch_name);
            else
                boundary_patch = [];
                disp('Error <MeshTopology> - getBoundayPatch!');
                disp(['> You entered patch name: ''', patch_name, ''' not existed']);
                disp('> Please new this patch via newBoundayPatch interface.');
            end
        end
    end
    
end

