function [e] = adj2edge(A)
[i, j] = find(A);
e = [i, j];
end