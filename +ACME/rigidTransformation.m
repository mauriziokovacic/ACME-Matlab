function [R] = rigidTransformation(P,T,Q)
W = Adjacency(P,T,'cot');
k = arrayfun(@(i) find(W(i,:)),(1:row(P))','UniformOutput',false);
R = cell(row(P),1);
for i = 1 : row(P)
    e       = P(i,:)-P(k{i},:);%-P(i,:);
    ee      = Q(i,:)-Q(k{i},:);%-Q(i,:);
    [~,~,d] = find(W(i,:));
    d       = diag(d);
    R{i} = rotationMatrix(covarianceMatrix(e,d,ee));
end
end

function [S] = covarianceMatrix(P,D,Q)
S = P' * D * Q;
end

function [R] = rotationMatrix(S)
[U,~,V] = svd(S);
R = V*U';
if(det(R)<=0)
    U(:,end) = -U(:,end);
end
R = V*U';
end