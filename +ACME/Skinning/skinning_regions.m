function [I] = skinning_regions(W)
[~, I] = sort(W,2,'descend');
I = I(:,1);
end