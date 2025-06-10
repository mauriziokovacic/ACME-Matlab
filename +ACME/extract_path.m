function [Q,varargout] = extract_path(P,N,T,F,B,e)
if( nargin < 6 )
    e = [1 row(F)];
end
Q = from_barycentric(P,T,F(e(1):e(2)),B(e(1):e(2),:));
if( nargout-1 > 0 )
varargout{1} = from_barycentric(N,T,F(e(1):e(2)),B(e(1):e(2),:));
end
end