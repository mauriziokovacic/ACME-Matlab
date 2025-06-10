function [n] = skinning_valence(W)
n = full(sum(logical(W),2));
end