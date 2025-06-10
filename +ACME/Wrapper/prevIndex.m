function [j] = prevIndex(n,i)
j = 1+mod(i+1+n,n);
end