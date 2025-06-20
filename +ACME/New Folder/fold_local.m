function [M,S,i] = fold_local(M,S,G,W,h)
h = [h;predecessors(G,h)];
[i,~] = find(W(:,h));
i = unique(i);
[~,~,t] = submesh(M.Face,i,'Type','node');
M = AbstractMesh('Vertex',M.Vertex(i,:),...
                 'Normal',M.Normal(i,:),...
                 'Face',t,...
                 'UV',M.UV(i,:));
S = AbstractSkin('Mesh',M,...
                 'Weight',S.Weight(i,:));
end