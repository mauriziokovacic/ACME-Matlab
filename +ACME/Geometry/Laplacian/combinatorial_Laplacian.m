function [ L ] = combinatorial_Laplacian( P, T )
A = Adjacency(P,T,'comb');
L = Laplacian(A,'std');
end