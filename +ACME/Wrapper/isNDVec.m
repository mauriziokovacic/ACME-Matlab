function [tf] = isNDVec(v,n)
tf = isvector(v) && (numel(v)==n);
end