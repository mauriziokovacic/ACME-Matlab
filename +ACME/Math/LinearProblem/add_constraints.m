function [M] = add_constraints( M, H, S )
e = @( i, n ) sparse( 1:numel(i) , i, 1, numel(i), n );
n = size(M,2);
if( nargin < 3 )
    S = [];
end
if( nargin < 2 )
    H = [];
end
if( ~isempty(H) )
    H = sort(H);
    M(H,:) = e( H, n );
end
if( ~isempty(S) )
    S = sort(S);
    m = sparse(numel(S),n);
    m(1:numel(S),:) = e( S, n );
    M = [M;m];
end
end