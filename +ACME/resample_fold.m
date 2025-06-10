function [CS] = resample_fold(Curve,n)
CS = [];
for c = 1 : numel(Curve)
C = Curve(c);
E = C.Edge;
P = getPoint(C);

A = P(E(:,1),:);
B = P(E(:,2),:);
M = 0.5*(A+B);

P = C.Mesh.Vertex;
T = C.Mesh.Face;
t = arrayfun(@(i) find(BC_inside(barycentric_coordinates(P,T,M(i,:)))),(1:row(M))','UniformOutput',false);
t = arrayfun(@(i) t{i}(min_index(abs(point_plane_distance(P(T(t{i},1),:),triangle_normal(P,T(t{i},:)),M(i,:))))),(1:row(M))','UniformOutput',false);
t = cell2mat(t);

S = arrayfun(@(i) struct('A',barycentric_coordinates(P,T(t(i),:),A(i,:)),...
                         'B',barycentric_coordinates(P,T(t(i),:),B(i,:)),...
                         'T',t(i) ),(1:row(M))');

k = parameter(C);
k = [k(1:end-1) k(2:end)];
[P,T] = sample(S,k,n(c));

EE = [(1:row(P)-1)' (2:row(P))'];
if(E(end)==E(1))
    P(end,:) = [];
    T(end)   = [];
    EE(end)  = EE(1);
end

M        = FoldCurve();
M.Mesh   = C.Mesh;
M.Skin   = C.Skin;
M.Point  = P;
M.Edge   = EE;
M.Face   = T;
M.Handle = C.Handle;
M.updateFrenetFrames();

CS = [CS;M];
end
end

function [P,T] = sample(S,k,n)
q = linspace(0,1,n);
i = findSegment(k,q);
P = cell2mat(arrayfun(@(ii) interp1(k(i(ii),1:2),[S(i(ii)).A;S(i(ii)).B],q(ii)),...
             (1:n)',...
             'UniformOutput',false));
T = arrayfun(@(ii) S(ii).T,i);
end

function [i] = findSegment(k,q)
[i,~] = find(q>=k(:,1)&q<=k(:,2),numel(q));
end