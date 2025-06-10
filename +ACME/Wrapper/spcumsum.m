function [O] = spcumsum(I,dim)
if(nargin<2)
    dim = 1;
end
[I,p,n] = shiftdata(sparse(I),dim);
O = double(logical(I));
S = zeros(1,col(O));
for i = 1 : row(I)
    S = S + I(i,:);
    O(i,:) = S .* O(i,:);
end
O = unshiftdata(O,p,n);
end