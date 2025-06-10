function [v] = valence(P,n)
if(nargin<2)
    n = maximum(P);
end
n = max(maximum(P),n);
E = unique(poly2edge(poly2edge(P)),'rows');
v = accumarray(E(:,1),1,[n 1]);
end