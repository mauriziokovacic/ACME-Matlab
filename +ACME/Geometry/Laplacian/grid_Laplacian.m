function [L] = grid_Laplacian(varargin)
A = grid_adjacency(varargin{:});
L = Laplacian(A,'std');
end