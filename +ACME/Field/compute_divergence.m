function [ D ] = compute_divergence( P, T, G )
n = row(P);
[I,J,K] = tri2ind(T);
Eij = P(J,:)-P(I,:);
Ejk = P(K,:)-P(J,:);
Eki = P(I,:)-P(K,:);   
[CTi, CTj, CTk] = triangle_cotangent(P,T);
Di = accumarray(I, CTk .* dotN( Eij, G ) + CTj .* dotN( -Eki, G ), [n 1] );
Dj = accumarray(J, CTi .* dotN( Ejk, G ) + CTk .* dotN( -Eij, G ), [n 1] );
Dk = accumarray(K, CTj .* dotN( Eki, G ) + CTi .* dotN( -Ejk, G ), [n 1] );
D = ( Di + Dj + Dk ) * 0.5;
end