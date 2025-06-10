function [out] = insertExtremity(W,E)
if(isempty(E))
    out = W;
    return;
end
E = sort(E);
n = max(col(W)+numel(E),max(E));
if(issparse(W))
    out = sparse(row(W),n);
else
    out = zeros(row(W),n);
end
i = 1 : col(W);
for e = 1 : numel(E)
    j = find(i>=E(e));
    if(isempty(j))
        break;
    end
    i(j) = i(j)+1;
end
out(:,i) = W;
end