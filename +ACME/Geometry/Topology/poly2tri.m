function [T,I] = poly2tri(P)
if(iscell(P))
    f = @(V,i) V{i};
else
    f = @(V,i) V(i,:); 
end
T = cell2mat(arrayfun(@(i) helper(f(P,i),i),(1:row(P))','UniformOutput',false));
I = T(:,end);
T = T(:,1:end-1);
end

function [T] = helper(P,n)
i = (1:row(P))';
j = (2:col(P)-1)';
k = mod(j,col(P))+1;
I = sub2ind(size(P),repelem(i,numel(j),1),ones(numel(i)*numel(j),1));
J = sub2ind(size(P),repelem(i,numel(j),1),repmat(j,row(P),1));
K = sub2ind(size(P),repelem(i,numel(j),1),repmat(k,row(P),1));
T = [P(I)' P(J)' P(K)' repmat(n,numel(I),1)];
end