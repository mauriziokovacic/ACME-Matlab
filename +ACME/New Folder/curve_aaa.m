F = fold_skeleton_weight(Skel,W);
k = 2;  
[m,s,v] = fold_local(M,S,Skel.Graph,W,FC(k).Handle);
I = v;
d = fold_distance(P(v,:), FC(k), F(v,:));

C = fold_level_curve(m,s,d,7);


g = curve_bbb(C,20);
[p,t,n,w] = g.proxy2mesh();

u = linspace(-1,1,50);
v = linspace(0,1,50);

p_ = g.fetchFoldPoint(u,v,true);
n_ = g.fetchFoldDirection(u,v,true);
w_ = g.fetchFoldWeight(u,v,true);
uu = g.fetchValue(u,v,true);

m = AbstractMesh('Vertex',p,'Normal',n,'Face',t);%quad2tri(polyflip(t)));
s = AbstractSkin('Mesh',m,'Weight',w);
lbs = LBSDeformer('Mesh',m,'Skin',s);
x = AbstractContact('Mesh',m,'Skin',s,'Point',p_,'Normal',n_,'Weight',w_,'Value',(sqrt(uu)));
cps = CPSDeformer('Mesh',m,'Skin',s,'Contact',x,'Operator',Op);
cps.show(Anim);





P_ = zeros(size(P));
N_ = P_;
W_ = sparse(row(P),col(W));
U_ = zeros(row(P),1);
uu = d/0.9;
vv = zeros(size(uu));
for j = 1 : numel(I)
K = g.extract_isocurve(uu(j),20);
[x,y] = K.project_point_on_curve(P(I(j),:));
vv(j) = y;
end
[P_(I,:),~,W_(I,:)] = g.fetch(zeros(size(uu)),vv,false);
[~,~,~,U_(I,:)] = g.fetch(uu,vv,false);
N_(I,:) = P(I,:)-g.fetch(-uu,vv,false);
N_(I,:) = normr(N_(I,:));
X  = AbstractContact('Mesh',M,'Skin',S);
X.Point = P_;
X.Normal = N_;
X.Weight = W_;
X.Value = U_;
CPS = CPSDeformer('Mesh',M,'Skin',S,'Contact',X,'Operator',Op);
CPS.show(Anim);



