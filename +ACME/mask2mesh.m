function [P,T] = mask2mesh(Mask)
[P,~,T] = Plane(1,size(Mask));
%[P,T]   = mesh2soup(P,T);
T       = T(logical(Mask'),:);
P       = P(unique(T),:);
T       = reindex(T);
[P,T]   = soup2mesh(P,T);
end