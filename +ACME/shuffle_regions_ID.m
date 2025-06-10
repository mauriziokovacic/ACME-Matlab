function [J] = shuffle_regions_ID(I)
n = max(I);
d = 0;
if( min(I) == 0 )
    d = 1;
end
n=n+d;
p = randperm(n)'-d;
J = p(I+d);
end