function [r] = triangle_ratio(P,T)
[I,J,K] = tri2ind(T);
Eij     = normr(P(J,:)-P(I,:));
Ejk     = normr(P(K,:)-P(J,:));
Eki     = normr(P(I,:)-P(K,:));
A       = [angle(Eij,-Eki), angle(Ejk,-Eij), angle(Eki,-Ejk)];
r       = min(A,[],2) ./ max(A,[],2);
end