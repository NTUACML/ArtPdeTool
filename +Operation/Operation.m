classdef Operation < handle
    %OPERATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        op_data_
    end
    
    methods
        function this = Operation()
            
        end
        
        function status = setOperator(this, op)
            this.op_data_ = op;
            status = true;
        end
        
        function expression = getExpression(this, method, varargin)
            switch(method)
                case 'FEM'
                    import Expression.FEM.*
                    if strcmp(this.op_data_,'grad_test_dot_grad_var')
                        % Bilinear form
                        if(~isempty(varargin) || ~(length(varargin{1}) < 2))
                            test = varargin{1}{1};
                            variable = varargin{1}{2};
                            expression = BilinearExpression();
                            expression.setTest(test);
                            expression.setVar(variable);
                        else
                            disp('Error <Operation>! - getExpression!');
                            disp('> the bilinear form should input test and variable.');
                        end
                    else
                        expression = Expression();
                    end
                case 'IGA'
                    import Expression.IGA.*
                    if strcmp(this.op_data_,'grad_test_dot_grad_var')
                        % Bilinear form
                        if(~isempty(varargin) || ~(length(varargin{1}) < 2))
                            test = varargin{1}{1};
                            variable = varargin{1}{2};
                            expression = BilinearExpression();
                            expression.setTest(test);
                            expression.setVar(variable);
                        else
                            disp('Error <Operation>! - getExpression!');
                            disp('> the bilinear form should input test and variable.');
                        end
                    else
                        expression = Expression();
                    end    
                otherwise
                    expression = [];
                    disp('Error <Operation>! - getExpression!');
                    disp('> Your input method not supported. ');
            end
        end
    end
    
end

