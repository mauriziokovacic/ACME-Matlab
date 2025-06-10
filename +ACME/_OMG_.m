p = (arrayfun(@(c) surfacePoint(c),FC,'UniformOutput',false));
t = (arrayfun(@(c) tangent(c),FC,'UniformOutput',false));
w = (arrayfun(@(c) [surfaceWeight(c) sparse(nPoint(c),1)],FC,'UniformOutput',false));
y = [];
i = [];
for c = 1 : numel(FC)
[y{c},i{c}] = project_on_bone(Skel,p{c});
end
yy = arrayfun(@(c) cell2mat(arrayfun(@(k) w{c}(k,i{c})*y{c}{k},(1:row(p{c}))','UniformOutput',false)),(1:numel(FC))','UniformOutput',false);
n = (arrayfun(@(j) normr(p{j}-yy{j}),(1:row(p))','UniformOutput',false));
b = (arrayfun(@(k) normr(cross(t{k},n{k},2)),(1:row(p))','UniformOutput',false));

P_ = cell2mat(arrayfun(@(k) p{X.Curve(k)}(X.CPoint(k),:), (1:row(P))','UniformOutput',false));
N_ = cell2mat(arrayfun(@(k) b{X.Curve(k)}(X.CPoint(k),:), (1:row(P))','UniformOutput',false));
N_ = reorient_plane(P_,N_,P);

tmp = WeightDeformer('Mesh',M,'Skin',S);
tmp.Point = P_;
tmp.Normal = N_;
tmp.Weight = X.Weight;
tmp.Value  = X.Value;
tmp.Operator = CPS.Operator;
tmp.show(Anim);
tmp.CoR = xx;





P_ = cell(1,numel(FC));
L = cotangent_Laplacian(P,T);
for k = 1 : numel(FC)
C = FC(k);
j = find(W(:,C.Handle));
i = unique(T(C.Face,:));
m = add_constraints(L,i);
x = zeros(size(P));
x(i,:) = P(i,:);
x = linear_problem(m,x);
P_{k} = x;
end

x = zeros(size(P));
for k = 1 : numel(FC)
KDT = KDTreeSearcher(P_{k});
j   = rangesearch(KDT,P_{k},0.2);
for i = 1 : row(P)
    x(i,:)   = x(i,:) + mean(P(setdiff(j{i},i),:),1);
end
end







%%%%%
k = nJoint(Skel);
w = [W sparse(row(P),k-col(W))];
p = referenceJointPosition(Skel);
n = referenceJointOrientation(Skel);
a = weight2adjacency(w);
tic
for k = 1 : k
    if(isRoot(Skel,k))
        continue;
    end
    i     = find(w(:,k) >= 0.5);
    if(isempty(i))
        continue;
    end
    j     = setdiff(find(a(k,:)),successors(Skel.Graph,k));
    [j,~] = find(w(:,j));
    j     = unique(j);
    if(isempty(j))
        continue;
    end
    x  = P(i,:)-p(k,:);
    y  = P(j,:)-p(k,:);
    dx = dotN(n(k,:),normr(x));
    dy = dotN(n(k,:),normr(y));
    rx = vecnorm(x,2,2);
    ry = vecnorm(y,2,2);
end
toc