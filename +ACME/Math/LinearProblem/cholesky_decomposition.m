function [Luu, Luk, L, Lt] = cholesky_decomposition(M,P,n_constraints)
n_free = col(M)-n_constraints;
Lw  = P * M * P';
Luu = Lw( 1:n_free, 1:n_free );
Luk = Lw( 1:n_free, n_free+1:end );
L   = chol( Luu, 'lower' );
Lt  = L';
end