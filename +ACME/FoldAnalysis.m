clear all; clc;

e = @( i, n ) sparse( 1:numel(i) , i, 1, numel(i), n );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ P, UV, N, E, T, S ] = import_Mesh( 'Data/Capsule' );
px = [min(P(:,1)) max(P(:,1))];
py = [min(P(:,2)) max(P(:,2))];
pz = [min(P(:,3)) max(P(:,3))];

% figure( 'Name', 'Original' ); display_mesh( P, N, T );
% axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[F, dF] = fold_field( S, 1 );
figure( 'Name', 'Fold Field' ); display_mesh( P, N, T, F );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G = compute_gradient( P, T, F );
D = compute_divergence( P, T, G );

I = field_discontinuity(dF,T);
I = I( F(I)<0.5 );
I = find( abs(P(:,1))<0.001 );
i = zeros( size(P,1), 1 );
i(I) = 1;

figure( 'Name', 'Fold Set' ); display_mesh( P, N, T, i );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = Kronecker_delta( I, size(P,1) );
A = barycentric_area( P, T );
L = cotangent_Laplacian( P, T );
t = diffusion_time( 1, mean_edge_length( P, T ) );

H = ( A + t * L ) \ K;

figure( 'Name', 'Heat Diffusion' ); display_mesh( P, N, T, H );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dH = compute_gradient( P, T, H );
nH = compute_divergence( P, T, dH );

U = L \ nH;

figure( 'Name', 'Geodesic Distance' ); display_mesh( P, N, T, U );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dU = compute_gradient( P, T, U );
nU = compute_divergence( P, T, dU );

% Z    = vertex_discontinuity(T,dU);%find( nU( vertex_discontinuity(T,dU) ) < 0 );
% Z    = find( nU(Z) < 0 );
Z    = find( nU < 0 );
Z = find(abs(P(:,1))> 70 );
z    = zeros( size(P,1), 1 );
z(Z) = 1;

figure( 'Name', 'Zero boundary' ); display_mesh( P, N, T, z );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C    = union(I,Z);
c    = zeros( size(P,1), 1 );
c(C) = 1;
figure( 'Name', 'Constraint Set' ); display_mesh( P, N, T, c );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = L;
M(C,:) = e( C, size(P,1) );
w = M \ K;

figure( 'Name', 'Fold Weight' ); display_mesh( P, N, T, w );
axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);
