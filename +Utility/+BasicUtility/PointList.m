classdef PointList < handle
    %POINTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_rows_
        num_cols_
        data_
    end
    
    methods
        function this = PointList(input_mat)
            import Utility.BasicUtility.Point
            [this.num_rows_, this.num_cols_] = size(input_mat);
            this.data_ = cell(this.num_rows_, 1);
            for i = 1 : this.num_rows_
                this.data_{i} = Point(this.num_cols_, input_mat(i,:));
            end
        end
        
        function data = subsref(this,S)
            if (S.type == '()')
                data = this.getSliceMethod(S.subs);
            elseif (S.type == '{}')
                data = this.getCellMethod(S.subs);
            else
                disp('Error<PointList> ! Check your slice or cell format!');
                data = [];
            end
        end
        
        function disp(this)
            disp('PointList Info:')
            disp(['Size : [ ', num2str(this.num_rows_), ' X ', ...
                num2str(this.num_cols_), ' ]'])
            disp(this.getSliceMethod({':',':'}))
        end
        
    end
    
    
    methods (Access = private)
        function data = getSliceMethod(this, subs)
            if(length(subs) ~= 2)
                disp('Error<PointList> ! Slice quarying should be a matrix style index!');
            end
            
            subs_rows = subs{1};
            subs_cols = subs{2};
            if(subs_rows == ':')
                subs_rows = 1 : this.num_rows_;
            end
            if(subs_cols == ':')
                subs_cols = 1 : this.num_cols_;
            end
            num_run_rows = length(subs_rows);
            num_run_cols = length(subs_cols);
            
            if(subs_rows(end) > this.num_rows_ ...
                    || ...
               subs_cols(end) > this.num_cols_)
               disp('Error<PointList> ! Check your slice dimension for all the points!');
               data = [];
            else
                data = zeros(num_run_rows, num_run_cols);
                for i = 1 : num_run_rows
                    data(i, :) = this.data_{subs_rows(i)}.data_(subs_cols);
                end
            end
        end
        
        function data = getCellMethod(this, subs)
            if(length(subs) ~= 1)
                disp('Error<PointList> ! Slice quarying should be a vector style index!');
            end
            
            subs_rows = subs{1};
            if(subs_rows == ':')
                subs_rows = 1 : this.num_rows_;
            end
            
            num_run_rows = length(subs_rows);
            if(subs_rows(end) > this.num_rows_)
               disp('Error<PointList> ! Check your cell dimension for all the points!');
               data = [];
            else
                data = cell(num_run_rows, 1);
                for i = 1 : num_run_rows
                    data{i} = this.data_{subs_rows(i)};
                end
            end
        end
    end
end

