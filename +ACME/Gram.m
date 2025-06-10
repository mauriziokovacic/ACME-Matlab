function [U] = Gram(V)
n = size(V,1);
k = size(V,2);
U = zeros(n,k);
if isa(V,'sym')
    U = sym(U);
end
U(:,1) = V(:,1)/sqrt(transpose(V(:,1))*V(:,1));
for i = 2:k
    U(:,i) = V(:,i);
    for j = 1:i-1
        U(:,i) = U(:,i) - ( transpose(U(:,i))*U(:,j) )/( transpose(U(:,j))*U(:,j) )*U(:,j);
    end
    U(:,i) = U(:,i)/sqrt(transpose(U(:,i))*U(:,i));
end
end