function [I] = normalize_region(I,W)
r = skinning_regions(W);
for b = 1 : size(W,2)
    i = find(r==b);
    I(i) = normalize(I(i));
end
end