function P = make_permutation(I,n)
x = zeros(n,1);
x(I) = 1;
x1 = cumsum(1-x) .* (1-x);
x2 = (max(x1)+cumsum(x)) .* x;
P = eye(n,n);
P = P(:,x1+x2);
end