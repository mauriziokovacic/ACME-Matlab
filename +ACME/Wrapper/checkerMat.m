function [M] = checkerMat(varargin)
parser = inputParser;
addOptional(parser,'Size',1,@(x) isscalar(x)||isvector(x));
parse(parser,varargin{:})
s = parser.Results.Size;
if(isscalar(s))
    s = [s s];
end
v = sparse(mod(1:prod(s),2));
M = double(bsxfun(@xor,v',v));
M = M(1:s(1),1:s(2));
end