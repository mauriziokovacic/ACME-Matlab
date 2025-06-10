function [tf] = BC_valid(B)
tf = sum(B,2)==1;
end