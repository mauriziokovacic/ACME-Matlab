function [B,IND,SIZ] = matrix_block(M,IND,siz,dim)
s = size(M);
if(nargin<4||isempty(dim))
    dim = 1:numel(s);
end
if(numel(dim)<numel(s))
    dim = [dim, setdiff(1:numel(s),dim)];
end
B = cell(numel(s),1);
SIZ = IND+siz-1;
for n = 1 : numel(IND)
    IND(n) = clamp(IND(n),1,s(dim(n)));
    SIZ(n) = clamp(SIZ(n),1,s(dim(n)));
    B{dim(n)} = IND(n):SIZ(n);
end
if( n < numel(s) )
    for n = n+1 : numel(s)
        B{dim(n)} = 1:s(n);
    end
end
B = M(B{:});
end