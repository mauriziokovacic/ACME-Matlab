function [F] = Gamma(W)
F = zeros(size(W));
n = (1 : size(W,2))';
for w = 1 : size(W,2)
    WW = sort(W(:,setdiff(n,w)),2,'descend');
    WW = WW(:,1);
    F(:,w) = W(:,w)-WW;
end
end