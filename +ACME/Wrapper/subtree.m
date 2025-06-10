function [g] = subtree(G, i)
g = i;
fun = @successors;
s = cell2mat(arrayfun(@(n) fun(G,n),i,'UniformOutput',false));
while(~isempty(s))
    j    = s(1);
    s(1) = [];
    if(ismember(j, g))
        continue;
    end
    g = [g; j];
    s = [s;fun(G, j)];
end
g = unique(g);
end