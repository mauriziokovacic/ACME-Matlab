function [P,N,T] = Triangle(scale)
if( nargin < 1 )
    scale = 1;
end
P = [equilateral_polygon(3,scale) zeros(3,1)];
N = repmat([0 0 1],row(P),1);
T = [1 2 3];
end