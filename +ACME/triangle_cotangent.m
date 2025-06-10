function [CTi, CTj, CTk] = triangle_cotangent( P, T )
[I,J,K] = tri2ind(T);
Eij = P(J,:)-P(I,:);
Ejk = P(K,:)-P(J,:);
Eki = P(I,:)-P(K,:);
CTi = cot3(Eij,-Eki);
CTj = cot3(Ejk,-Eij);
CTk = cot3(Eki,-Ejk);
end