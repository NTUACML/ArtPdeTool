classdef InterfaceDifferential < Differential.DifferentialBase
    %INTERFACEDIFFERENTIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        differential_m_
        differential_s_
    end
    
    methods
        function this = InterfaceDifferential(basis, patch)
            this@Differential.DifferentialBase(basis, patch);
            import Differential.IGA.Differential
            this.differential_m_ = Differential(basis{1}, this.patch_.master_patch_);
            this.differential_s_ = Differential(basis{2}, this.patch_.slave_patch_);
        end
        
    end
end

