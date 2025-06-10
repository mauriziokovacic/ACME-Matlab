function [tf] = ishypercube(M)
s = size(M);
tf = ~any(s(1)~=s);
end