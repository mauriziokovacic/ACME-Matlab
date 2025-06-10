function [ B, N, U ] = face_data( P, T, F )
if(nargin<3)
    F = [];
end
i = 1;
j = 2;
k = 3;
I = T(:,i);
J = T(:,j);
K = T(:,k);
Eij = P(J,:)-P(I,:);
Eki = P(I,:)-P(K,:);
N = normr( cross(Eij, -Eki, 2) );
B = (P(I,:)+P(J,:)+P(K,:)) / 3;
if(~isempty(F))
U = (F(I)+F(J)+F(K)) / 3;
end
end