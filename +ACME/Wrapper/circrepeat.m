function [val] = circrepeat(val,n,dim)
if((nargin<3)||isempty(dim))
    dim = 1;
end
s = size(val);
p = zeros(1,numel(s));
p(dim) = n;
val = padarray(val,p,'circular','post');
end