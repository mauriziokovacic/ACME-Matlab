function [tf,I] = BC_on_vertex(B)
I     = zeros(row(B),1);
B     = B==1;
tf    = sum(B,2)==1;
[~,i] = find(B(tf));
I(tf) = i;
end