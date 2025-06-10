function [P] = ind2poly(I,n)
I = make_column(I);
P = reshape(I,n,row(I)/n)';
end