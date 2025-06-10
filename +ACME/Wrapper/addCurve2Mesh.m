function [P,T,E,I,J] = addCurve2Mesh(P,T,S)
table = {[],...
         [1 5 4; 2 3 5; 3 4 5],...
         [2 5 4; 3 1 5; 1 4 5],...
         [3 4 5; 1 2 4; 2 5 4],...
         [3 5 4; 1 2 5; 2 4 5],...
         [2 4 5; 3 1 4; 1 5 4],...
         [1 4 5; 2 3 4; 3 5 4],...
         []};
     
split = @(code,ind) cell2mat(cellfun(@(i,t) i(t),...
                                     num2cell(ind,2),table(code)',...
                                     'UniformOutput',false) );

[Q,T]    = mesh2soup(P,T);
N        = normr([1 1 1]);
A        = from_barycentric(Q,T,S.T,S.A);
B        = from_barycentric(Q,T,S.T,S.B);
t        = S.T;
ax       = normr(S.B-S.A);
X        = bi2de([sign_of(-signed_angle(ax,normr([1 0 0]-S.A),N)) ...
                  sign_of(-signed_angle(ax,normr([0 1 0]-S.A),N)) ...
                  sign_of(-signed_angle(ax,normr([0 0 1]-S.A),N)) ...
           ]>0)+1;
Q        = [Q;A;B];
i        = row(Q)-2*numel(t)+1;
j        = row(Q)-1*numel(t)+1;
T        = [ T; split(X,[T(t,:) (i:(j-1))' (j:row(Q))'])];
T(S.T,:) = [];
[Q,T]    = soup2mesh(Q,T);
KDTree   = KDTreeSearcher(Q);
E        = knnsearch(KDTree,interleave(A,B),'K',1);
E        = reshape(E,2,numel(E)/2)';
i        = find(valence(E)==1,row(Q));
i        = find(ismember(E(:,1),i));
E        = [E(i,:);E(setdiff(1:row(E),i),:)];
E        = sortEdgeChain(E);
I        = [E(:,1);E(end)];
J        = unique(knnsearch(KDTree,P,'K',1),'stable');
P        = Q;
end