function [tf] = isskinny(M)
tf = (numel(size(M))==2)&&(row(M)>col(M));
end