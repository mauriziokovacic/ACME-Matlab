function [j] = nextIndex(n,i)
j = 1+mod(i,n);
end