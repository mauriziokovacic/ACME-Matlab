function [P,T] = CatmullSub(P,T,iter)
if(nargin<3)
    iter = 1;
end
if(~isquad(T))
    error('Catmull-Clarke subdivision defined only on quad meshes');
end
for i = 1 : iter
    [P,T] = CatmullIter(P,T);
    [P,T] = soup2mesh(P,T);
end
end

function [P,T] = CatmullIter(P,T)
C = (1:row(T))';

[I,J,K,L] = quad2ind(T);
E       = [I J;J K;K L;L I];
F       = [K L;L I;I J;J K];

[E,~,j] = unique(sort(E,2),'rows');
e       = (1:row(E))';
IJ      = (1:row(T))';
JK      = row(T)+IJ;
KL      = row(T)+JK;
LI      = row(T)+KL;

Face    = sparse(repmat(C,4,1),[I;J;K;L],1/4,row(T),row(P));

Edge    = sparse([     e;         e;        e(j);       e(j)     ],...
                 [E(:,1);    E(:,2);      F(:,1);     F(:,2)     ],...
                 [repmat(3/8,row(E)*2,1); repmat(1/16,row(F)*2,1)],...
                 row(e),row(P));
Edge     = Edge(j,:);

Vert    = topoAdjacency(T);
k       = full(sum(Vert,2));
beta    = BetaFcn(k);
gamma   = GammaFcn(k);

Vert    = (Vert.*(beta./k));
Vert    = Vert + sparse([I;J;K;L],...
                        [K;L;I;J],...
                        gamma([I;J;K;L])./k([I;J;K;L]),...
                        row(Vert),col(Vert));
Vert    = Vert + speye(row(Vert),col(Vert)).*(1-beta-gamma);

X       = interleave(Vert( I,:), Edge(IJ,:),Face, Edge(LI,:),...
                     Vert( J,:), Edge(JK,:),Face, Edge(IJ,:),...
                     Vert( K,:), Edge(KL,:),Face, Edge(JK,:),...
                     Vert( L,:), Edge(LI,:),Face, Edge(KL,:));
P       = X*P;
T       = reshape(1:row(P),4,row(P)/4)';
end

function [beta] = BetaFcn(k)
beta = 3./(2.*k);
end

function [gamma] = GammaFcn(k)
gamma = 1./(4.*k);
end