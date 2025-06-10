function [PP] = ARAP(P,PP,T,iteration)
if(( nargin < 3 ) || (isempty(iteration)))
    iteration = 3;
end
W = Adjacency(P,T,'cot');
i = find(sum(W,2)==0);
W(sub2ind(size(W),i,i)) = 1;
W = num2cell(W,2);
I = num2cell((1:row(P))');
J = cellfun(@(w)   find(w),                        W,  'UniformOutput',false);
W = cellfun(@(w)   nonzeros(w),                    W,  'UniformOutput',false);
W = cellfun(@(w)   spdiags(w,0,numel(w),numel(w)), W,  'UniformOutput',false);
E = cellfun(@(i,j) (P(i,:)-P(j,:))',               I,J,'UniformOutput',false);
L = decomposition(cotangent_Laplacian(P,T)+speye(row(P))*0.0001);
for iter = 1 : iteration
    EE = cellfun(@(i,j) (PP(i,:)-PP(j,:))',I,J,'UniformOutput',false);
    R  = ARAP_Rotation(E,EE,W);
    b  = ARAP_b(E,W,R,I,J);
    PP = L\b;
end

end

function [R] = ARAP_Rotation(E,EE,W)
R = cellfun( @(P,PP,D) ARAP_Derivation(full(P*D*PP')), E, EE, W, 'UniformOutput',false);
end

function [R] = ARAP_Derivation(S)
[U,~,V] = svd(S);
% Change sign of last column of U so det(R)>0
R = V*U';
end

function [b] = ARAP_b(E,W,R,I,J)
b = (cellfun(@(i,j) ARAP_bi(W(i),R(i),R(j),E(i)),I,J,'UniformOutput',false));
b = cell2mat(b);
end

function [b] = ARAP_bi(Wi,Ri,Rj,Ei)
R = cellfun(@plus, repmat(Ri,row(Rj),1), Rj,'UniformOutput',false);
E = cellfun(@(r,e) r*e, R, num2cell(cell2mat(Ei),1)','UniformOutput',false);
b = sum(cell2mat(E') * Wi{1},2)';
end