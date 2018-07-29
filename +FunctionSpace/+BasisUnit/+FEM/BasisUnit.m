classdef BasisUnit < FunctionSpace.BasisUnit.BasisUnitBase
    %BASISUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position_        % basis maximum value position
        order_          % basis order
        is_essential_bc % is essential boundary condition? (bool)
    end
    
    methods
        function this = BasisUnit(id)
            this = this@FunctionSpace.BasisUnit.BasisUnitBase(id);
            import Utility.BasicUtility.Order
            this.order_ = Order.Linear;
            this.is_essential_bc = false;
        end
    end
    
end

