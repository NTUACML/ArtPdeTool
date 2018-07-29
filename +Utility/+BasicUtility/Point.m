classdef Point < handle
    %POINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dim_        % point dimension
        data_       % point data
    end
    
    methods
        function this = Point(dim, varargin)
           this.dim_ = dim;
           this.data_ = zeros(1, this.dim_);
           if(~isempty(varargin))
               this.setData(varargin{1});
           end
        end
     
        function disp(this)
            disp(this.data_)
        end
        
        function x = getX(this)
            x = this.data_(1);
        end
        
        function y = getY(this)
            if(dim >= 2)
                y = this.data_(2);
            else
                y = 0;
            end
        end
        
        function z = getZ(this)
            if(dim >= 3)
                z = this.data_(3);
            else
                z = 0;
            end
        end
        
    end
    
    methods (Access = private)
        function setData(this, data)
            this.data_ = data;
        end
    end
    
end

