function [W] = weight2superbone(W,N)
if( nargin < 2 )
    N = 2;
end
if(N<=1)
    return;
end
A = weight2adjacency(W);
k = [];
for i = 1 : row(A)
    j = find(A(i,:));
    if(isempty(j))
        continue;
    end
    n = min(N-1,numel(j));
    w = combnk(j,n);
    k = [k;zeros(row(w),abs(n-N+1)) repmat(i,row(w),1) w];
end
k = unique(sort(k,2),'rows');
k = cellfun(@(c) unique(erase_zero(c)),num2cell(k,2),'UniformOutput',false);
if(ispoolactive())
    WW = cell(1,row(k));
    parfor i = 1 : row(k)
        WW{i} = sum(W(:,k{i}),2);
    end
    W = WW;
else
    W = arrayfun(@(i) sum(W(:,k{i}),2),(1:row(k))','UniformOutput',false)';
end
W = cell2mat(W);
end