function [F] = Sigma(W)
W = sort(W,2,'descend');
F = W(:,2)./W(:,1);
end