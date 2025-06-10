function [P] = skeletonRoot2Node(G)
R = skeletonRoot(G);
P = cell(numnodes(G),1);
for i = 1 : numnodes(G)
    for j = 1 : numel(R)
        P{i} = shortestpath(G,R(j),i);
        if(~isempty(P{i}))
            break;
        end
    end
end
end