function [tf,I] = BC_on_edge(B)
I     = zeros(row(B),1);
B     = B==0;
tf    = sum(B,2)==1;
[~,i] = find(B(tf,:));
I(tf) = mod(i,3)+1;
end