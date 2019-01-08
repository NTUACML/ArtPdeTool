function [Qw, UQ] = KnotIns(p, Pw, UP, u, r)
% Input: p, UP, Pw, u, r, 
% Output: UQ, Qw
import BasisFunction.IGA.NurbsBasisFunction

[N_m, N_n, N_q]=size(Pw);

np = length(UP) - p - 2;
k = NurbsBasisFunction.FindSpan(np, p, u, UP);
k = k + 1;
mp = np + p + 1;
nq = np + r;

UQ=zeros(1,length(UP)+r);

for i = 1:k 
    UQ(i) = UP(i);
end
for i = 1:r 
    UQ(k + i) = u;
end                             
for i = (k + 1):(mp + 1)    
    UQ(i + r) = UP(i);
end            

for j = 1:r
   L = k - p + j;                                           
   for i = 0:(p - j)                                 
       alpha(i + 1,j) = (u - UP(L + i))/(UP(i + 1 + k) - UP(L + i));
   end
end

for q = 1:N_q
    for n = 1:N_n  %%%%%
        Local_Pw=[];
        for m = 1:N_m  
            Local_Pw(m,:) = [Pw{m,n,q}];
        end 
        for row = 0:mp
            for i=0:(k - p - 1)
                Local_Qw(i + 1,row + 1) = Local_Pw(i + 1,row + 1);
            end
            for i = k:(np+1)  %%%%%+1
                Local_Qw(i + r,row + 1) = Local_Pw(i,row + 1);
            end
            for i=0:p
                Rw(i + 1) = Local_Pw(k - p + i ,row + 1); %-1
            end
            for j = 1:r
                L = k - p + j;                                          
                for i = 0:(p - j)                                  
                    Rw(i + 1) = alpha(i + 1,j) * Rw(i + 2) + (1.0 - alpha(i + 1,j)) * Rw(i + 1);
                    Local_Qw(L,row + 1) = Rw(1);
                    Local_Qw(k + r - j,row + 1) = Rw(p - j + 1);
                end
                for i = (L + 1):k
                    Local_Qw(i,row + 1) = Rw(i - L + 1);
                end
            end
        end
        sizeQ = size(Local_Qw);
        for i = 1:sizeQ(1) %%%%%
            Qw{i,n,q} = Local_Qw(i,:);
        end
    end
end
%UQ

end


