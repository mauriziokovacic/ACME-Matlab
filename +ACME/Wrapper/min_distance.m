function [i,d] = min_distance(P,Q)
[d,i] = sort(cell2mat(arrayfun(@(j) distance(P,Q(j,:)),(1:row(Q)),'UniformOutput',false)),2,'ascend');
i = i(:,1);
d = d(:,1);
end