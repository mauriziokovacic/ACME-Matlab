function [A] = adj2cell(A)
E = adj2edge(A);
A = cell(row(A),1);
for i = 1 : row(E)
A{E(i,1)} = [A{E(i,1)}, E(i,2)];
end
end