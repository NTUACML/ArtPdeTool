classdef BasisUnit < FunctionSpace.BasisUnit.BasisUnitBase
    %BASISUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position_       % basis center position
        order_          % basis order
        support_size_   % basis support size
        is_essential_bc % is essential boundary condition? (bool)
    end
    
    methods
        function this = BasisUnit(id)
            this = this@FunctionSpace.BasisUnit.BasisUnitBase(id);
            import Utility.BasicUtility.Order
            this.order_ = Order.Linear;
            this.support_size_ = 0;
            this.is_essential_bc = false;
        end
        
        function SetSupportSize(this, value)
            this.support_size_ = value;
        end
    end
    
end

