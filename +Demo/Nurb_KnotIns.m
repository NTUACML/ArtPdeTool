function [new_points, new_knots] = Nurb_KnotIns(Nurbs, u)
% Input: p(matrix), knots(cell), point(matrix), u(cell), basis_num(cell)
% Output: new_points, new_knots
import Utility.BasicUtility.TensorProduct

knots=Nurbs.knot_vectors_;
p=Nurbs.order_;
point=Nurbs.control_points_(:,:);
basis_n=Nurbs.basis_number_;

while length(basis_n) < 3
    basis_n(1,end+1) = 1;
end

%Rearrange point list to cubic
TD = TensorProduct({basis_n(1) basis_n(2) basis_n(3)});
point_L = basis_n(1) * basis_n(2) * basis_n(3);
for k = 1:point_L
    pos = TD.to_local_index(k);
    Pw(pos{1},pos{2},pos{3}) = {point(k,:)};
end

Dim = length(knots);
switch Dim
    case 1
        UP = knots{1};
        u_u = u{1};
        %insert u-durection
        if isempty(u_u) 
            UQ = UP;
        else
            uni = unique(u_u);
            n = histc(u_u,uni);
            Qw = Pw;
            U = UP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, U] = Demo.KnotIns(p(1), Qw, U, local_u, r); %
            end
            UQ = U;
            Pw = Qw;
        end
        new_knots = {UQ};
        
    case 2
        UP = knots{1}; VP = knots{2};
        u_u = u{1}; v_u = u{2};
        %insert u-durection
        if isempty(u_u) 
            UQ = UP;
        else
            uni = unique(u_u);
            n = histc(u_u,uni);
            Qw = Pw;
            U = UP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, U] = Demo.KnotIns(p(1), Qw, U, local_u, r); %
            end
            UQ = U;
            Pw = Qw;
        end
        %insert v-durection
        if isempty(v_u) 
            VQ = VP;
        else
            uni = unique(v_u);
            n = histc(v_u,uni);
            Qw = permute(Pw, [2 1 3]);
            U = VP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, U] = Demo.KnotIns(p(2), Qw, U, local_u, r); %
            end
            VQ = U;
            Pw = permute(Qw,[2 1 3]);
        end
        new_knots = {UQ, VQ};
        
    case 3
        UP = knots{1}; VP = knots{2}; WP = knots{3};
        u_u = u{1}; v_u = u{2}; w_u = u{3};
        %insert u-durection
        if isempty(u_u) 
            UQ = UP;
        else
            uni = unique(u_u);
            n = histc(u_u,uni);
            Qw = Pw;
            U = UP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, U] = Demo.KnotIns(p(1), Qw, U, local_u, r); %
            end
            UQ = U;
            Pw = Qw;
        end
        
        %insert v-durection
        if isempty(v_u) 
            VQ = VP;
        else
            uni = unique(v_u);
            n = histc(v_u,uni);
            Qw = permute(Pw,[2 1 3]);
            U = VP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, U] = Demo.KnotIns(p(2), Qw, U, local_u, r); %
            end
            VQ = U;
            Pw = permute(Qw,[2 1 3]);
        end
        
        %insert w-durection
        if isempty(w_u) 
            WQ = WP;
        else
            uni = unique(w_u);
            n = histc(w_u,uni);
            Qw = permute(Pw,[3 2 1]);
            U = WP;
            for i = 1:length(uni)
                local_u = uni(i);
                r = n(i);
                [Qw, U] = Demo.KnotIns(p(3), Qw, U, local_u, r);%
            end
            WQ = U;
            Pw = permute(Qw,[3 2 1]);
        end
        new_knots = {UQ, VQ, WQ};      
end

%Rearrange cubic control point to point-list type
[N_i, N_j, N_k] = size(Pw);
TD_3 = TensorProduct({N_i N_j N_k});
for k = 1:N_k
    for j = 1:N_j 
        for i = 1:N_i 
            global_index = TD_3.to_global_index({i j k});
            new_points(global_index, :) = Pw{i, j, k};
        end
    end
end
end
