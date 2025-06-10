function [V] = mat2lin(M)
if(iscell(M))
    V = cell2mat(cellfun(@(m) helper(m),M,'UniformOutput',false));
else
    V = helper(M);
end
end

function [V] = helper(M)
f = @(d,n) d(1:n);
V = f(M',numel(M)-col(M));
end