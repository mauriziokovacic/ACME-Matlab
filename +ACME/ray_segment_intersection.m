function [ X, varargout ] = ray_segment_intersection( O, D, A, B )
if( size(O,1) == 1 )
    O = repmat(O,size(A,1),1);
    D = repmat(D,size(A,1),1);
end
if( size(A,1) == 1 )
    A = repmat(A,size(O,1),1);
    B = repmat(B,size(O,1),1);
end
X = NaN(size(O));
E1 = O - A;
E2 = B - A;
N  = cross( E1, E2, 2 );
z = abs(dotN( N, D ));
E3 = normr(cross( D, N, 2 ));
dt = dotN( E2, E3 );
t1 = vecnorm3( N ) ./ dt;
t2 = dotN( E1, E3 ) ./ dt;

z( abs(z)   < 0.0001 ) = 0;
t1( abs(t1) < 0.0001 ) = 0;
t2( abs(t2) < 0.0001 ) = 0;
t2( abs(t2-1) < 0.0001 ) = 1;

I = find( ( z <= 0.0001 ) &...
          ( t1 >= 0 ) & ...
          ( t2 >= 0 ) & ...
          ( t2 <= 1 ) );
X(I,:) = A(I,:) + t2(I,:) .* E2(I,:);
if( nargout > 1 )
    t1( t1 < 0 ) = NaN;
    varargout{1} = t1;
end
if( nargout > 2 )
    t2( t2 < 0 ) = NaN;
    t2( t2 > 1 ) = NaN;
    varargout{2} = t2;
end
if( nargout > 3 )
    varargout{3} = I;
end
if( nargout > 4 )
    varargout{4} = z;
end