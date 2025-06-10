function [M] = lin2mat(V)
M = arrayfun(@(i) helper(V(i,:)),(1:row(V))','UniformOutput',false);
if(numel(M)==1)
    M = M{1};
end
end

function [M] = helper(V)
n = ceil(sqrt(numel(V)));
M = reshape(V,[n n-1])';
M = [M; zeros(1,col(M)-1) 1];
end