function [i,ders] = DersBasisFuns(u, p, U, varargin)
% Compute the non-vanishing basisfunction and it's derivative
% Input: i, u, p, U
% Output: ders
import BasisFunction.IGA.NurbsBasisFunction

% compute span index integer
n = length(U) - p - 2;
i = NurbsBasisFunction.FindSpan(n,p,u,U);

ndu(1,1) = 1;

for j=1:p
    
    left(j+1) = u - U(i+2-j);
    right(j+1) = U(i+j+1) - u;
    saved = 0.0;

    for r = 0:j-1
        %lower trinagle
        ndu(j+1,r+1) = right(r+2)+ left(j-r+1);
        temp = ndu(r+1,j) / ndu(j+1,r+1);
        
        % upper triangle
        ndu(r+1,j+1) = saved + right(r+2) * temp;
        saved = left(j-r+1)*temp;
    end
    ndu(j+1,j+1) = saved;
end

% load the basisfunctions
ders = ndu(:,p+1)';
if isempty(varargin)
    nDer = 1;
else
    nDer = varargin{1};
end

% This section computes the derivatives
for r=0:p
    s1=0; s2=1;
    a(1,1) = 1;
    
    % loop to compute kth derivative
    for k=1:nDer
        d=0;
        rk=r-k; pk = p-k;
        if (r >= k)
            a(s2+1,1) = a(s1+1,1) / ndu(pk+2,rk+1);
            d = a(s2+1,1) * ndu(rk+1,pk+1);
        end
        if (rk >= -1) 
            j1 = 1;
        else
            j1 = -rk;
        end
        if (r-1 <= pk)
            j2 = k-1;
        else
            j2 = p-r;
        end
        
        for j=j1:j2
            a(s2+1,j+1) = (a(s1+1,j+1) - a(s1+1,j)) / ndu(pk+2,rk+j+1);
            d = d + a(s2+1,j+1) * ndu(rk+j+1,pk+1);
        end
        
        if (r <= pk)
            a(s2+1,k+1) = - a(s1+1,k) / ndu(pk+2,r+1);
            d = d + a(s2+1,k+1) * ndu(r+1,pk+1);
        end
     ders(k+1,r+1) = d;
     j = s1; s1 = s2; s2 = j;
    end
end

% multiply by the correct factors
r = p;
for k=1:size(ders,1)-1
    for j=0:p
        ders(k+1,j+1) = ders(k+1,j+1) * r;
    end
    r = r*(p-k);
end

% load basisfunctions and its derivatives in the variable arguments list
ders = ders(1:nDer+1,:)';