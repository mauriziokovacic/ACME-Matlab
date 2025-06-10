function [C] = interleave(varargin)
n = nargin;
r = row(varargin{1});
C = [];
if(n==0)
    return;
end
C = reshape( cell2mat(cellfun(@(x) x(:),varargin,'UniformOutput',false))',n*r, []);
end