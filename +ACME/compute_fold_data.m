function compute_fold_data( filename )

e = @( i, n ) sparse( 1:numel(i) , i, 1, numel(i), n );


[ P, ~, N, ~, T ] = import_GEO( filename );
[ W, F ]          = import_SKN( filename );
[ I ]             = import_vertex_list( [filename,'Fold_0'] );

K = Kronecker_delta( I, size(P,1) );
A = barycentric_area( P, T );
L = cotangent_Laplacian( P, T );
t = diffusion_mass( P, T, W );

AtL = A + t * L;

AtL(I,:) = e( I, size(P,1) );

H = AtL \ K;

dH = compute_gradient( P, T, H );
nH = compute_divergence( P, T, dH );

dH = full( dH );
nH = full( nH );

nH(find( abs(nH) < 0.0001 )) = 0;
L = L + speye(size(L))*0.0001;

U = L \ nH;
U = (U-min(U))/(max(U)-min(U));
U(I) = 1;

dU = compute_gradient( P, T, U );
nU = compute_divergence( P, T, dU );

display_mesh(P,N,T,U);

export_FLD( filename, U, dU, nU );

end