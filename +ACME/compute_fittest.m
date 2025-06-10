function [Q,U] = compute_fittest( P, N, T, iter )
if( nargin < 4 )
    iter = 3;
end
% A = Adjacency(P,T,'cot');
% K = sum(A,2);
Q = P;
U = N;

n = size(P,1);
I = T(:,1);
J = T(:,2);
K = T(:,3);
Ni = N(I,:);
Nj = N(J,:);
Nk = N(K,:);
Cij = dot(Ni,Nj,2);
Cjk = dot(Nj,Nk,2);
Cki = dot(Nk,Ni,2);
ij = find(Cij>0.1);
jk = find(Cjk>0.1);
ki = find(Cki>0.1);
E = [I(ij) J(ij); J(jk) K(jk); K(ki) I(ki)];
E = unique( sortrows( sort( E, 2 ) ), 'rows' );
E = [E(:,1) E(:,2); E(:,2) E(:,1)];
A = sparse( E(:,1), E(:,2), 1, n, n );
K = sum(A,2);

for i = 1 : iter
Q = A*Q ./ K;
U = normr(A*U);
end
end