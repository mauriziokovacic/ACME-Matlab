function [A] = combinatorial_adjacency(P,n)
if(nargin<2)
    n = maximum(P);
end
n = max(maximum(P),n);
E = unique(poly2edge(poly2edge(P)),'rows');
A = sparse(E(:,1),E(:,2),1,n,n);
end