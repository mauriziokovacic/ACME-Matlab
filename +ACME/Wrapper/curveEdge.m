function [E] = curveEdge(n, closed)
if( nargin < 2 )
    closed = false;
end
E = [(1:n-1)' (2:n)'];
if( closed )
    E(end) = 1;
end
end