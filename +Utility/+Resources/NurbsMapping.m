function [p] = NurbsMapping(xi, nurbs)
[p,w] = nrbeval(nurbs, {xi(:,1), xi(:,2)});
p = p/w;
end

