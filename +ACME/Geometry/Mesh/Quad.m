function [P,N,T] = Quad()
P = [[-1 -1; 1 -1; 1 1; -1 1],zeros(4,1)];
T = [1 2 3 4];
N = repmat([0 0 1],4,1);
end