function [E] = boundary(T)
E = poly2edge(T);
[~,j,e] = unique(sort(E,2),'stable','rows');
E = E(j(accumarray(e,1)==1),:);
end