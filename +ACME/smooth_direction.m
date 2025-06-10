function [N] = smooth_direction(G,Adj,iteration,include_vertex)
if( nargin < 4 )
    include_vertex = true;
end
if( nargin < 3 )
    iteration = 3;
end
[I,J] = ind2sub(size(Adj),find(Adj));
N = G;
if( include_vertex )
    for i = 1 : iteration
        N = accumarray3([(1:size(N,1))';I],[N;N(J,:)]);
        S = accumarray([(1:size(N,1))';I],ones(size(N,1)+numel(I),1));
        N = normr(N./S);
    end
else
    N = G;
    for i = 1 : iteration
        N = accumarray3(I,N(J,:));
        S = accumarray(I,ones(numel(I),1));
        N = normr(N./S);
    end
end
end