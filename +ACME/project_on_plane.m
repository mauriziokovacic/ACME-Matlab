function [ X, varargout ] = project_on_plane( P, N, Q, varargin )
D = point_plane_distance( P, N, Q );
X = Q - D .* N;
if( ( nargout == 2 ) && ( nargin > 3 ) )
    U = project_on_plane(P,N,Q+varargin{1});
    varargout{1} = U-X;
end
end