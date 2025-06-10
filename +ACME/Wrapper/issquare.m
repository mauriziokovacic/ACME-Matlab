function [tf] = issquare(M)
tf = numel(size(M)==2)&&ishypercube(M);
end