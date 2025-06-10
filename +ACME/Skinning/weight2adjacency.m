function [A] = weight2adjacency(W)
e = [];
for i = 1 : row(W)
    j = find(W(i,:))';
    e = [e; repmat(j,numel(j),1) repelem(j,numel(j),1)];
    e = unique(e,'rows');
end
e(e(:,1)==e(:,2),:) = [];
A = sparse(e(:,1),e(:,2),1,col(W),col(W));
end