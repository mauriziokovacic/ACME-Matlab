function [ B ] = barycentric_coordinates( P, T, Q, varargin )
if( nargin == 3 )
    [I,J,K] = tri2ind(T);
    Pi = P(I,:);
    Pj = P(J,:);
    Pk = P(K,:);
end
if( nargin == 4 )
    Pi = P;
    Pj = T;
    Pk = Q;
    Q  = varargin{1};
end
if( row(Q) == 1 )
    Q = repmat(Q,row(T),1);
end
B = zeros(row(Q),3);
Ei = Pk - Pi;
Ej = Pj - Pi;
Ek = Q  - Pi;
Dii = dot( Ei, Ei, 2 );
Dij = dot( Ei, Ej, 2 );
Dik = dot( Ei, Ek, 2 );
Djj = dot( Ej, Ej, 2 );
Djk = dot( Ej, Ek, 2 );
d = 1 ./ ( Dii .* Djj - Dij .* Dij );
B(:,3) = (Djj .* Dik - Dij .* Djk) .* d;
B(:,2) = (Dii .* Djk - Dij .* Dik) .* d;
B(:,1) = 1 - B(:,2) - B(:,3);
B(abs(B)<0.0001) = 0;
B = B./sum(B,2);
end