function DemoTensorProduct
%DEMOTENSORPRODUCT Summary of this function goes here
%   Detailed explanation goes here
clc; clear; close all;

import Utility.BasicUtility.TensorProduct

N_i = 3;
N_j = 2;
N_k = 4;

%%
TD_3 = TensorProduct({N_i N_j N_k});
  
for k = 1 : N_k
    for j = 1 : N_j
        for i = 1 : N_i
            global_index = TD_3.to_global_index({i j k});
            str = [num2str(i), ' ', num2str(j), ' ', num2str(k), ' : ', num2str(global_index)];
            disp(str);
        end
    end
end
disp('----------------------------------');
for k = 1 : TD_3.total_num_
    local_index = TD_3.to_local_index(k);
    str = [num2str(local_index{1}), ' ', num2str(local_index{2}), ' ', num2str(local_index{3}), ' : ', num2str(k)];
    disp(str);
end

disp('----------------------------------');
disp('----------------------------------');
%%
TD_2 = TensorProduct({N_i N_j});
  
for j = 1 : N_j
    for i = 1 : N_i
        global_index = TD_2.to_global_index({i j});
        str = [num2str(i), ' ', num2str(j), ' : ', num2str(global_index)];
        disp(str);
    end
end
disp('----------------------------------');
for k = 1 : TD_2.total_num_
    local_index = TD_2.to_local_index(k);
    str = [num2str(local_index{1}), ' ', num2str(local_index{2}), ' : ', num2str(k)];
    disp(str);
end



end

