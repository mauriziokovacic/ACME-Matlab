function [tf] = BC_outside(B)
tf = sum((B>1|B<0),2)>0;
end