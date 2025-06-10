function [C,nC] = nodeColor(A)
n  = row(A);
C  = zeros(n,1);
nC = 1;
A  = logical(tril(A,-1));
for i = 1 : n
    nc = unique(C(A(i,:)));
    c  = min(setdiff(1:nC,nc));
    if isempty(c)
        nC = nC + 1;
        c  = nC;
    end
    C(i) = c;
end
end