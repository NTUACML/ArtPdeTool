function [Final_Q,new_knots] = Nurb_KnotIns( p, point, knots, u, basis_num)
% Input: p, knots, point, u, basis_num
% Output: new_points, new_knots
import Utility.BasicUtility.TensorProduct

while length(basis_num)<3
    basis_num{end+1}=1
end

TD = TensorProduct(basis_num);
point_L = basis_num{1} *  basis_num{2} * basis_num{3};

for k=1:point_L
pos = TD.to_local_index(k);
Pw(pos{1},pos{2},pos{3}) = {point(k,:)};
end

Dim = length(knots);
switch Dim
    case 1
        UP = knots{1};
        uu = u{1};
        %insert u-durection
        if isempty(uu) 
            UQ = UP;
        else
            uni = unique(uu);
            n = histc(uu,uni);
            Qw=Pw;
            knot=UP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, knot] = Demo.KnotIns(p(1), Qw, knot, local_u,r); %%%%%%%%%%%%%%
            end
            UQ=knot;
            Pw=Qw;
        end
        new_knots={UQ};
        
    case 2
        UP=knots{1};VP=knots{2};
        uu=u{1};vu=u{2};
        %insert u-durection
        if isempty(uu) 
            UQ=UP;
        else
            uni = unique(uu);
            n = histc(uu,uni);
            Qw=Pw;
            knot=UP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, knot] = Demo.KnotIns(p(1), Qw, knot, local_u,r); %%%%%%%%%%%%%%
            end
            UQ=knot;
            Pw=Qw;
        end
        
        %insert v-durection
        if isempty(vu) 
            VQ=VP;
        else
            uni = unique(vu);
            n = histc(vu,uni);
            Qw=permute(Pw,[2 1 3]);
            knot=VP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, knot] = Demo.KnotIns(p(2), Qw, knot, local_u,r); %%%%%%%%%%%%%%
            end
            VQ=knot;
            Pw=permute(Qw,[2 1 3]);
        end
        new_knots={UQ, VQ};
        
    case 3
        UP=knots{1};VP=knots{2};WP=knots{3};
        uu=u{1};vu=u{2};wu=u{3};
        %insert u-durection
        if isempty(uu) 
            UQ=UP;
        else
            uni = unique(uu);
            n = histc(uu,uni);
            Qw=Pw;
            knot=UP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, knot] = Demo.KnotIns(p(1), Qw, knot, local_u,r); %%%%%%%%%%%%%%
            end
            UQ=knot;
            Pw=Qw;
        end
        
        %insert v-durection
        if isempty(vu) 
            VQ=VP;
        else
            uni = unique(vu);
            n = histc(vu,uni);
            Qw=permute(Pw,[2 1 3]);
            knot=VP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, knot] = Demo.KnotIns(p(2), Qw, knot, local_u,r); %%%%%%%%%%%%%%
            end
            VQ=knot;
            Pw=permute(Qw,[2 1 3]);
        end
        
        %insert w-durection
        if isempty(wu) 
            WQ=WP;
        else
            uni = unique(wu);
            n = histc(wu,uni);
            Qw=permute(Pw,[3 2 1]);
            knot=WP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, knot] = Demo.KnotIns(p(3), Qw, knot, local_u,r); %%%%%%%%%%%%%%
            end
            WQ=knot;
            Pw=permute(Qw,[3 2 1]);
        end
        new_knots={UQ, VQ,WQ};
        
end

[N_i, N_j, N_k]=size(Pw);
TD_3 = TensorProduct({N_i N_j N_k}); %%%%%%

for k=1:N_k
    for j=1:N_j %%%%%
        for i=1:N_i %%%%%
            global_index = TD_3.to_global_index({i j k});
            Final_Q(global_index,:)=Pw{i,j,k};
        end
    end
end
end

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
