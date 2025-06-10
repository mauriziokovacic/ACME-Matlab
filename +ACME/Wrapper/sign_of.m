function [s] = sign_of(x)
s = ones(size(x));
s(x<=0) = -1;
end