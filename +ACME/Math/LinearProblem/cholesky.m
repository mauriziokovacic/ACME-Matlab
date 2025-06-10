function [x] = cholesky(A,b,i)
n  = col(A);
P  = make_permutation(i,n);
vk = b(i);
M  = add_constraints(A,i,[]);
[Luu, Luk, L, Lt] = cholesky_decomposition(M,P,numel(i));
x                 = cholesky_problem(Luk,L,Lt,vk,P);
end