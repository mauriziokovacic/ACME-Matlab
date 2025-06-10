function [P,T] = LoopSub(P,T,iter)
if(nargin<3)
    iter = 1;
end
T = poly2tri(T);
for i = 1 : iter
    [P,T] = LoopIter(P,T);
    [P,T] = soup2mesh(P,T);
end
end

function [P,T] = LoopIter(P,T)
[I,J,K] = tri2ind(T);
E       = [I J;J K;K I];
F       = [K;I;J];
[E,~,j] = unique(sort(E,2),'rows');
e       = (1:row(E))';
IJ      = (1:row(T))';
JK      = row(T)+IJ;
KI      = row(T)+JK;
Odd     = sparse([e;e;e(j)],...
                 [E(:,1);E(:,2);F],...
                 [repmat(3/8,row(E)*2,1);repmat(1/8,numel(F),1)],...
                 row(e),row(P));
Odd     = Odd(j,:);
Even    = topoAdjacency(T);
n       = full(sum(Even,2));
beta    = BetaFcn(n);
Even    = (Even.*beta) + speye(row(Even),col(Even)).*(1-n.*beta);
X       = interleave(Even( I,:),Odd(IJ,:),Odd(KI,:),...
                     Even( J,:),Odd(JK,:),Odd(IJ,:),...
                     Even( K,:),Odd(KI,:),Odd(JK,:),...
                      Odd(IJ,:),Odd(JK,:),Odd(KI,:));
P       = X*P;
T       = reshape(1:row(P),3,row(P)/3)';
end

function [beta] = BetaFcn(n)
beta       = zeros(size(n));
i          = find(n<3);
j          = find(n>3);
beta(i)    = (1./n(i)) .* ( (5/8) - ( (3/8) + (1/4) .* cos((2*pi)./n(i)).^2 ) );
beta(n==3) = 3/16;
beta(j)    = 3 ./ (8*n(j));
end