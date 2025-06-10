function [S] = sigmoid(X)
S = 1./(1+exp(-X));
end