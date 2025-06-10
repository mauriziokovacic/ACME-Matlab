function [R] = create_region(T,W,C)
R = cell(col(W),1);
W = vertex2face(W,T);
for r = 1 : col(W)
    t = find(W(:,r));
    v = unique(T(t,:));
    R{r} = struct('V',v,'T',t,'C',[]);
end
for c = 1 : row(C)
    w = mean(C{c}.W);
    r = find(w);
    for i = 1 : numel(r)
        R{r(i)}.C = [R{r(i)}.C;c];
    end
end
end
