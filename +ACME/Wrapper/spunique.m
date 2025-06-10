function [C,ia,ic] = spunique(A)
K = col(A);
sp = issparse(A);
if(K<=10)
    A = full(A);
    M = KDTreeSearcher(A);
else
    M = ExhaustiveSearcher(A);
end
ia = knnsearch(M,A,'K',1);
ic = unique(ia,'stable');
C  = A(ic,:);
if(sp~=issparse(A))
    C = sparse(C);
end
end