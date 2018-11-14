classdef TensorProduct
    %TENSORPRODUCT Summary of this class goes here
    %   dim_, num_ : 3, {n_i, n_j, n_k} 
    %   dim_, num_ : 2, {n_i, n_j}
    %   dim_, num_ : 1, {n_i}
    
    properties
        dim_
        num_
        total_num_
    end
    
    methods
        function this = TensorProduct(num)
            this.num_ = num;
            this.dim_ = size(num, 2);
            this.total_num_ = prod(cell2mat(num));
        end
        
        function global_index = to_global_index(this, local_index)
            switch this.dim_
                case 3
                    global_index = (local_index{3}-1)*this.num_{1}*this.num_{2} + (local_index{2}-1)*this.num_{1} + local_index{1};
                case 2
                    global_index = (local_index{2}-1)*this.num_{1} + local_index{1};
                case 1
                    global_index = local_index{1};
                otherwise
                    disp('The dimension of input local index is not correct!');
            end
        end
        
        function local_index = to_local_index(this, global_index)
            switch this.dim_
                case 3
                    local_index = {0 0 0};
                    quo = fix(global_index/(this.num_{1}*this.num_{2}));
                    rem = mod(global_index, this.num_{1}*this.num_{2});
                    
                    if abs(rem) < eps
                       quo = quo - 1;
                       rem = this.num_{1}*this.num_{2};
                    end
                    
                    local_index{3} = quo + 1;
                    
                    quo = fix(rem/this.num_{1});
                    rem = mod(rem, this.num_{1});
                    
                    if abs(rem) < eps
                       quo = quo - 1;
                       rem = this.num_{1};
                    end
                    
                    local_index{1} = rem;
                    local_index{2} = quo + 1;
                    
%                     temp = mod(global_index, this.num_{1}*this.num_{2});
%                     local_index{1} = mod(temp, this.num_{1});
%                     local_index{2} = fix(temp/this.num_{1}) + 1;
%                     local_index{3} = fix(global_index/(this.num_{1}*this.num_{2})) + 1;            
                case 2
                    local_index = {0 0};
                    quo = fix(global_index/this.num_{1});
                    rem = mod(global_index, this.num_{1});
                    
                    if abs(rem) < eps
                       quo = quo - 1;
                       rem = this.num_{1};
                    end
                    
                    local_index{1} = rem;
                    local_index{2} = quo + 1;

                case 1
                    local_index{1} = global_index;
                otherwise
                    disp('The dimension of input local index is not correct!');
            end
        end
    end
    
end

