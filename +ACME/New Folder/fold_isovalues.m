function [iso] = fold_isovalues(D, n)
d = min(max(D),abs(min(D)));
iso = linspace(-d,d,n);
end