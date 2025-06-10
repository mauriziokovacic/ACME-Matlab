function [l] = edge_length(P,T)
E = unique(sort(poly2edge(T),2),'rows');
l = distance(P(E(:,1),:),P(E(:,2),:));
end