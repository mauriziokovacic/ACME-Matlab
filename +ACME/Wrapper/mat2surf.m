function [h] = mat2surf(M,Limits,varargin)
if( nargin < 2 )
    Limits = [ones(2,1) size(M)'];
end
[X, Y] = meshgrid(linspace(Limits(1,1),Limits(1,2),row(M)),linspace(Limits(2,1),Limits(2,2),col(M)));
h = surf( X, Y, M, 'EdgeColor', 'none', 'FaceColor', 'interp', varargin{:} );
% hold on;
% contour3( X, Y, M, linspace( min(min(M)), max(max(M)), 11 ), 'LineColor', 'k' );
end