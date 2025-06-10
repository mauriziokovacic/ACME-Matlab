function [h] = quiv2( P,N, varargin )
if( row(P) == 1 )
    P = repmat(P,row(N),1);
end
if( row(N) == 1 )
    N = repmat(N,row(P),1);
end
h = quiver(P(:,1),P(:,2),N(:,1),N(:,2),varargin{1:end});
end