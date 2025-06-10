function [W] = PinocchioWeights(M,S,e,threshold)
if(nargin<4)
    threshold = 0.01;
end
if(nargin<3)
    e = 0.5;
end
P     = M.Vertex;
T     = M.Face;
n     = row(P);
if(isa(S,'BaseSkeleton'))
    m     = numnodes(S.Graph);
    [i,d] = closestBone(S,P);
else
    m     = row(S);
    [i,d] = min_distance(P,S);
end
L     = cotangent_Laplacian(P,T);
H     = speye(n).*(1./(d.^e));
p     = sparse((1:n)',i,1,n,m);
W     = linear_problem((L+H),(H*p));
W(abs(W)<threshold) = 0;
W     = W ./ sum(W,2);
end