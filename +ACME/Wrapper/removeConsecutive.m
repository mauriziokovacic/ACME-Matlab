function [V] = removeConsecutive(V)
V = make_column(V);
tf = false(row(V),col(V));
for i = 1 : col(V)
    tf(:,i) = [false;V(2:end,i) == V(1:end-1,i)];
end
tf = prod(tf,2);
V = V(~tf,:);
end