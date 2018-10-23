function span = FindSpan(n, p, u, U)

% Determine the knot span index
% Input: u, p, u, U
% Output: the knot span index

if (u == U(n+2))
    span = n;
else
    low = p;
    high = n + 1;
    mid = round((low + high)/2);
    
    while ((u < U(mid)) || (u >= U(mid + 1)))
        if (u < U(mid))
            high = mid;
        else
            low = mid;
        end
        
        mid = round((low + high)/2);
    end
    
    span = mid-1;
    
end
        
