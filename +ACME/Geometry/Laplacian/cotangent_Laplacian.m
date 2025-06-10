function [ L ] = cotangent_Laplacian( P, T )
A = Adjacency( P, T, 'cot' );
L = Laplacian( A, 'std' );
end