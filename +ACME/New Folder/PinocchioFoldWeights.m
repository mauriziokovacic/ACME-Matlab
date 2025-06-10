function [W] = PinocchioFoldWeights(M,S,F,e,threshold)
if(nargin<5)
    threshold = 0.01;
end
if(nargin<4)
    e = 0.5;
end
P     = M.Vertex;
T     = M.Face;
n     = row(P);
m     = numnodes(S.Graph);
[i,d] = closestBone(S,P);
L     = cotangent_Laplacian(P,T);
H     = speye(n).*(1./(d.^e));
p     = sparse((1:n)',i,1,n,m);
for c = 1 : numel(F)
    C = F(c);
    p = [p;...
        sparse(repmat((1:numel(C.Point))',numel(C.Handle),1),...
               repelem(make_column(C.Handle),numel(C.Point),1),...
               1/numel(C.Handle),...
               numel(C.Point),m)];
    H = [H;H(C.Point,:)];
    L = [L;L(C.Point,:)];
end
W     = linear_problem((L+H),(p));
W(abs(W)<threshold) = 0;
W     = W ./ sum(W,2);
end