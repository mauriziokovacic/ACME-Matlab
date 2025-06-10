function [VV,VE,VF,EF] = adjacency_matrices(P,T)
n = size(P,1);
t = size(T,1);
I = T(:,1);
J = T(:,2);
K = T(:,3);
F = (1:t)';
L = unique( sort( [I J; J K; K I], 2 ), 'rows' );
e = size(L,1);
E = (1:e)';
VV = sparse([I;J;K;J;K;I],[J;K;I;I;J;K],1,n,n) / 2;
VE = sparse([L(:,1);L(:,2)],[E;E],1,n,e);
VF = sparse([I;J;K],[F;F;F],1,n,t);
EF = VE'*VF;
end