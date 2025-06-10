function [A] = grid_adjacency(varargin)
siz = cell2mat(varargin);
if numel(siz) == 1
    siz = [siz siz];
end
[i,j] = meshgrid(1:siz(1),1:siz(2));
E = [i(:) j(:)];
E = [E E+[1 0]; E E+[-1  0];...
     E E+[0 1]; E E+[ 0 -1]];
E(any(E==0,2) | (E(:,3)>siz(1)) | (E(:,end)>siz(2)), :) = [];
E = [sub2ind(siz, E(:, 1), E(:, 2)) sub2ind(siz, E(:, 3), E(:, end))];
A = sparse(E(:, 1),E(:, 2), 1, prod(siz), prod(siz));
end