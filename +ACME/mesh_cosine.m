function [ T ] = mesh_cosine( A, B )
T = dot( normr(A.N), normr(B.N), 2 );
end