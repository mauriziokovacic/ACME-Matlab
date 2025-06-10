function [R] = skeletonRoot(G)
R = [];
for i = 1 : numnodes(G)
    if(isempty(predecessors(G,i)))
        R = [R;i];
    end
end
end