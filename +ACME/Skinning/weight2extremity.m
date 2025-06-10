function [i] = weight2extremity(W)
i = find(arrayfun(@(j) full(~any(W(:,j))),(1:col(W))'));
end