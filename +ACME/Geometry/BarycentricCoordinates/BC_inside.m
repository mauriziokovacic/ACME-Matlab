function [tf] = BC_inside(B)
tf = ~BC_outside(B);
end