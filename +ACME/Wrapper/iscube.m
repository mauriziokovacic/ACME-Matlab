function [tf] = iscube(M)
tf = (numel(size(M))==3)&&ishypercube(M);
end