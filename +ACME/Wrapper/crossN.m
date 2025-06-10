function [N] = crossN(varargin)
N = vertcat(varargin{:});
n = 1:col(N);
N = arrayfun(@(i) det(N(:,setdiff(n,i))),n);
end