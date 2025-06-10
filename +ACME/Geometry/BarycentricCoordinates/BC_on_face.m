function [tf] = BC_on_face(B)
tf = sum((B>=1|B<=0.0001),2)==0;
end