function [X] = split_handle_surface(M,W,G)
X = cell(col(W),1);
for h = 1 : col(W)
    i = [subtree(G, h);predecessors(G,h)];
    [i,~] = find(W(:,i));
    i = unique(i);
    It = submesh(M.Face,i,'Type','node');
    X{h} = It;
end
end