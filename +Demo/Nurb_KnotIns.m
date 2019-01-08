%function [new_points,new_knots] = Nurb_KnotIns( p, points, knots, u)
clear;clc
import BasisFunction.IGA.NurbsBasisFunction
import Utility.BasicUtility.TensorProduct

srf = nrb4surf([0 0 0 1],[0 1 0 1],[1 0 0 1],[1 1 0 1]) ;
test=nrbkntins(srf,{[] [0.25]});
p=[1];
point=[0 0 0 1;1 0 0 1;0 1 0 1;1 1 0 1];

TD_2 = TensorProduct({2 2});

for k=1:4
pos=TD_2.to_local_index(k)
Pw(pos{1},pos{2})={point(k,:)}
end

knots{1}=[0 0 1 1];
knots{2}=[0 0 1 1];
UP=knots{1};
VP=knots{2};
u=[0.25];
r=1;

testP=permute(Pw,[2 1])

testB=Demo.KnotIns(p, testP, UP, u, r)

B=permute(testB,[2 1])

[N_i N_j N_k]=size(B);
TD_3 = TensorProduct({N_i N_j N_k}); %%%%%%

for k=1:N_k
    for j=1:N_j %%%%%
        for i=1:N_i %%%%%
            global_index = TD_3.to_global_index({i j k});
            Final_Q(global_index,:)=B{i,j,k};
        end
    end
end
Final_Q


% p=[2,2]
% points{1}=[0.5,1.5,4.5,3,7.5,6,8.5];
% points{2}=[3,5.5,5.5,1.5,1.5,4,4.5];
% knots{1}=[0,0,0,0.25,0.5,0.75,0.75,1,1,1];
% knots{2}=[0,0,0,0.25,0.5,0.75,0.75,1,1,1];
% u={[0.125] [0]}    
%     Dim=length(knots);
%        
% for j=1:Dim
%     if ~isempty(u{j}) ~=0
%         local_p=p(j);
%         Qw = points{j};
%         UQ = knots{j};
%         uni = unique(u{j});
%         n = histc(u{j},uni);
%         for i = 1:length(uni)
%             local_u = uni(i);
%             r = n(i);
%             [Qw, UQ] = Demo.KnotIns(local_p, Qw, UQ, local_u,r); %%%%%%%%%%%%%%
%         end
%         new_points{j} = Qw;
%         new_knots{j} = UQ;  
%     else
%         new_points{j} = points{j}
%         new_knots{j} = knots{j}
%     end
% end
% new_points
% end
% 
% 
