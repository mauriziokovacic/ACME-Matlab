function [ U, V, W ] = compute_frame( P, N, T, G, type )
if( nargin < 5 )
    type = 'std';
end
n = size(P,1);
t = size(T,1);
W = normr( N );
if( n ~= t )
    i = 1;
    j = 2;
    k = 3;
    I = T(:,i);
    J = T(:,j);
    K = T(:,k);
    si = repmat([I;J;K],3,1);
    sj = [ones(3*t,1) 2*ones(3*t,1) 3*ones(3*t,1)];
    u = [repmat(G(:,i),3,1);repmat(G(:,j),3,1);repmat(G(:,k),3,1);];
    U = normr( full( sparse( si, sj, u, n, 3 ) ) );
%     U = normr( project_on_plane( P, W, U ) );
else
    U = G;
end
V = normr( cross( W, U, 2 ) );
if( strcmp(type,'proj') )
    U = normr( cross( V, W, 2 ) );
end
end