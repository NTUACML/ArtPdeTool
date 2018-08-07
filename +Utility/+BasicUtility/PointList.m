classdef PointList < handle
    %POINTLIST - A container for the point.
    %   here is the demo code for the PointList
    %
    %       % Initial input matrix
    %       input_mat = [1 2 3; 4 5 6; 7 8 9; 10 11 12; 13 14 15];
    %
    %       % Create PointList
    %       point_list = PointList(input_mat);
    %
    %       % Modify value (only modified value in point)
    %       point_list(1:2:5,:) = [0,0,0; 0 0 0; 0 0 0];
    %
    %       % Modify value (reset and new a point in point_list)
    %       point_list{1:2} = [1, 1, 1; 2, 2, 2];
    %
    %       % Display all the data in PointList
    %       disp(point_list)
    %
    %       % Slicing sub-matrix for the point list
    %       mat_point = point_list(1:2:5,1);
    %
    %       % Slicing points cell data for the point list
    %       cell_point = point_list{1:2:5};
    properties
        num_rows_ = 0
        num_cols_ = 0
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
        
        function this = subsasgn(this,S, B)
            import Utility.BasicUtility.Point
            if (S.type == '()')
                this = setSliceMethod(this, S.subs, B);
            elseif (S.type == '{}')
                this = setCellMethod(this, S.subs, B);
            else
                disp('Error<PointList> ! Check your slice or cell format!');
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
        function this = setSliceMethod(this, subs, B)
            if(length(subs) ~= 2)
                disp('Error<PointList> ! Slice quarying should be a matrix style index!');
            end
            [b_num_rows_, b_num_cols_] = size(B);
            
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
            elseif(num_run_rows > b_num_rows_ ...
                    || ...
                   num_run_cols > b_num_cols_)
               disp('Error<PointList> ! Check your right hand side dimension in slicing assigment!');
            else
                for i = 1 : num_run_rows
                    this.data_{subs_rows(i)}.data_(subs_cols) = B(i, :);
                end
            end
            
        end
        
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
        
        function this = setCellMethod(this, subs, B)
            import Utility.BasicUtility.Point
            if(length(subs) ~= 1)
                disp('Error<PointList> ! Slice quarying should be a vector style index!');
            end
            
            [b_num_rows_, b_num_cols_] = size(B);
            
            subs_rows = subs{1};
            if(subs_rows == ':')
                subs_rows = 1 : this.num_rows_;
            end
            
            num_run_rows = length(subs_rows);

            if(subs_rows(end) > this.num_rows_)
               disp('Error<PointList> ! Check your cell dimension for all the points!');
            elseif(num_run_rows > b_num_rows_ || b_num_cols_ > this.num_cols_)
               disp('Error<PointList> ! Check your right hand side dimension in cell slicing assigment!');
            else
                for i = 1 : num_run_rows
                    this.data_{subs_rows(i)} = Point(this.num_cols_, B(i,:));
                end
            end
        end
    end
end

