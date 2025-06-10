function [P_,N_,W_,U_,g] = fold_data(Mesh,Skin,Skel,Handle,Selection)
h = Handle;
i = Selection;

F  = fold_skeleton_weight(Skel,Skin.Weight);
F  = F(:,h);
FC = FoldCurve.createFromData(Mesh.Vertex,Mesh.Normal,Mesh.Face,F);
F  = F(i,:);

[~,~,t] = submesh(Mesh.Face,i,'Type','node');
M = AbstractMesh('Vertex',Mesh.Vertex(i,:),...
                 'Normal',Mesh.Normal(i,:),...
                 'Face',t,...
                 'UV',Mesh.UV(i,:));
S = AbstractSkin('Mesh',M,...
                 'Weight',Skin.Weight(i,:));

% FC = FoldCurve.createFromData(M.Vertex,M.Normal,M.Face,F);

d = fold_distance(M.Vertex, FC, F);
C = fold_level_curve(M,S,d,7);
g = curve_bbb(C,20);


u = d/max(abs(d));
v = zeros(size(u));
for j = 1 : numel(i)
    K = g.extract_isocurve(u(j),20);
    [~,v(j)] = K.project_point_on_curve(Mesh.Vertex(i(j),:));
end

P_ = g.fetchFoldPoint(u,v,false);
N_ = g.fetchFoldDirection(u,v,false);
W_ = g.fetchFoldWeight(u,v,false);
U_ = g.fetchValue(u,v,false);
end