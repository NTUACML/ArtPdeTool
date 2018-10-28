classdef Expression < Expression.ExpressionBase
    %EXPRESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        test_
        var_
    end
    
    methods
        function this = Expression()
            this@Expression.ExpressionBase();
        end
        
        function setTest(this, test)
            this.test_ = test;
        end
        
        function setVar(this, var)
            this.var_ = var;
        end
        
    end
    
end

