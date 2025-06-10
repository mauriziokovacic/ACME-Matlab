U = zeros(row(P),1);
option = import_FRG([path,'Selection']);

tic

eul2rotm
for iter = 1 : row(option)

% Gather data
P = M.Vertex;
N = M.Normal;
T = M.Face;
W = S.Weight;

% Select bone(s)
h = option{iter,1};%selectBone();
[j,~] = find(W(:,h));
j = unique(j);

% Select bone(s) subtree
if(option{iter,3})
    h = subtree(G,h);
end

% Extract fold curve
f = sum(W(:,h),2);
C = FoldCurve.createFromData(P,N,T,f);

% Compute point-curve distance
s = sign(f-0.5);
D = distance(P,C.getPoint(),2);

% Select distance
d_max = max(D(j));
% D     = clamp(D/d_max,0,1);
d     = d_max*option{iter,2};%selectDistance();

% Select vertices by region growing
[i,j] = region_growing(P,T,D,min_index(D),@(f) f<=d);
i = find(i);
j = find(j);

% Extract submesh
[~,~,t] = submesh(T,i,'Type','node');
M_prime = AbstractMesh('Vertex',P(i,:),'Normal',N(i,:),'Face',t);
S_prime = AbstractSkin('Mesh',M_prime,'Weight',W(i,:));

% Sign distance
D = s.*D;

% Extract level curves
k = 7;
K = fold_level_curve(M_prime,S_prime,D(i),k,d);

% Create proxy
CP = curve2proxy(K,20);

[p,t,n,w] = CP.proxy2mesh();
u = linspace(-1,1,50);
v = linspace(0,1,50);
p_ = CP.fetchFoldPoint(u,v,true);
n_ = CP.fetchFoldDirection(u,v,true);
w_ = CP.fetchFoldWeight(u,v,true);
uu = CP.fetchValue(u,v,true);
m = AbstractMesh('Vertex',p,'Normal',n,'Face',t);
s = AbstractSkin('Mesh',m,'Weight',w);
lbs = LBSDeformer('Mesh',m,'Skin',s);
x = AbstractContact('Mesh',m,'Skin',s,'Point',p_,'Normal',n_,'Weight',w_,'Value',(sqrt(uu)));
cps = CPSDeformer('Mesh',m,'Skin',s,'Contact',x,'Operator',Op);
clear p t n w u v p_ n_ w_ uu

% Create contact data
if( ~exist('X','var') )
    X = AbstractContact('Mesh',   M,...
                        'Skin',   S,...
                        'Point',  zeros(size(P)),...
                        'Normal', zeros(size(P)),...
                        'Weight', sparse(row(P),col(W)),...
                        'Value',  zeros(row(P),1));
end

% Map mesh onto proxy
i = j;
u = D(i)/d;
v = zeros(size(u));
parfor j = 1 : numel(i)
    c     = CP.extract_isocurve(u(j),20);
    [~,t] = c.project_point_on_curve(P(i(j),:));
    v(j)  = t;
end

[~,~,~,x] = CP.fetch(u,v,false);
x = sqrt(x);

j = find(x>U(i));
i = i(j);
u = u(j);
v = v(j);
x = x(j);
U(i) = x;

X.Value(i,:) = x;
[X.Point(i,:),~,X.Weight(i,:)] = CP.fetch(zeros(size(u)),v,false);
X.Normal(i,:) = P(i,:)-CP.fetch(-u,v,false);
X.Normal(i,:) = normr(X.Normal(i,:));

% Create CPS deformer
CPS = CPSDeformer('Mesh',M,'Skin',S,'Contact',X,'Operator',Op);

clear c d h i j k t u v; %s
end

toc