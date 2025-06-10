function [varargout] = triangle_cosine(P,T)
[I,J,K] = tri2ind(T);
Eij = normr(P(J,:)-P(I,:));
Ejk = normr(P(K,:)-P(J,:));
Eki = normr(P(I,:)-P(K,:));
varargout = {dotN(Eij,-Eki),dotN(Ejk,-Eij),dotN(Eki,-Ejk)};
end