function [ A ] = triangle_area( P , T )
[I,J,K] = tri2ind(T);
Eij = P(J,:)-P(I,:);
Eik = P(K,:)-P(I,:);
A = 0.5 * vecnorm3(cross(Eij, Eik, 2));
end