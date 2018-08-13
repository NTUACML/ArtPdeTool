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
    %       % Modify value (replaced point)
    %       tmp_list = PointList([0 0 0; 1, 1, 1]);
    %       point_list{1:2} = tmp_list;
    %
    %       % Display all the data in PointList
    %       disp(point_list)
    %
    %       % Slicing sub-matrix for the point list
    %       mat_point = point_list(1:2:5,1);
    %
    %       % Slicing points cell data for the point list
    %       cell_point = point_list{1:2:5};
    %       
    %       % New a PointList by cell slicing
    %       new_point = PointList(cell_point)
    
    properties
        num_rows_ = 0
        num_cols_ = 0
        data_
    end
    
    methods
        
        function this = PointList(input)
            if(isa(input, 'Utility.BasicUtility.PointList'))
                this.num_rows_ = input.num_rows_;
                this.num_cols_ = input.num_cols_;
                this.data_ = cell(this.num_rows_, 1);
                for i = 1 : this.num_rows_
                    this.data_{i} = input.data_{i};
                end
            else
                import Utility.BasicUtility.Point
                [this.num_rows_, this.num_cols_] = size(input);
                this.data_ = cell(this.num_rows_, 1);
                for i = 1 : this.num_rows_
                    this.data_{i} = Point(this.num_cols_, input(i,:));
                end
            end
        end
        
        function this = subsasgn(this,S, B)
            import Utility.BasicUtility.Point
            if (S.type == '()')
                this = setSliceMethod(this, S.subs, B);
            elseif (S.type == '{}')
                this = setCellMethod(this, S.subs, B);
            elseif (S.type == '.')
                switch(S.subs)
                    case 'num_rows_'
                    	this.num_rows_ = B;
                    case 'num_cols_'
                        this.num_cols_ = B;
                    case 'data_'
                        this.data_ = B;
                    otherwise
                end
            else
                disp('Error<PointList> ! Check your slice or cell format!');
            end
        end
        
        function data = subsref(this,S)
            len_s = length(S);
            if(len_s == 1)
                if (S.type == '()')
                    data = this.getSliceMethod(S.subs);
                elseif (S.type == '{}')
                    data = this.getCellMethod(S.subs);
                elseif (S.type == '.')
                    switch(S.subs)
                        case 'num_rows_'
                            data = this.num_rows_;
                        case 'num_cols_'
                            data = this.num_cols_;
                        case 'data_'
                            data = this.data_;
                        otherwise
                            data = [];
                    end
                else
                    disp('Error<PointList> ! Check your slice or cell format!');
                    data = [];
                end
            else
                if(S(1).type == '.')
                    switch(S(1).subs)
                        case 'data_'
                            if(S(2).type == '{}')
                                data = this.data_{S(2).subs{1}};
                            else
                                data = [];
                            end
                        case 'size'
                            if(S(2).type == '()')
                                data = this.num_rows_;
                            else
                                data = [];
                            end
                        otherwise
                            data = [];
                    end
                else
                    data = [];
                end
            end

        end
        
        function disp(this)
            disp('PointList Info:')
            disp(['Size : [ ', num2str(this.num_rows_), ' X ', ...
                num2str(this.num_cols_), ' ]'])
            if(this.num_rows_ == 0 || this.num_cols_ == 0)
            else
                disp(this.getSliceMethod({':',':'}))
            end
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
                import Utility.BasicUtility.PointList
                data = PointList([]);
                data.num_rows_ = num_run_rows;
                data.num_cols_ = this.num_cols_;
                data.data_ = cell(data.num_rows_, 1);
                for i = 1 : num_run_rows
                    data.data_{i} = this.data_{subs_rows(i)};
                end
                
            end
        end
        
        function this = setCellMethod(this, subs, B)
            import Utility.BasicUtility.Point
            if(length(subs) ~= 1)
                disp('Error<PointList> ! Slice quarying should be a vector style index!');
            end
            
            b_num_rows_ = B.num_rows_;
            b_num_cols_ = B.num_cols_;
            
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
                    this.data_{subs_rows(i)} = B.data_{i};
                end
            end
        end
    end
end

