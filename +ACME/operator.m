function [X] = operator()
n = 512;
b = sparse(n);
I = [];
J = [];

for k = 0 : 8
name = ['Img/', num2str(k), 'd8.png'];
Im = imread(name);
Im = im2bw(Im,0);
i = ((k/8)*(n/2))+1;
[v,j] = find(Im);
v = (j/n).*(1-2.*(v-1)./(n-1));
b(i,j)= v;
I = [I;repmat(i,size(j,1),1)];
J = [J;j];
end

for i = [1,384,512]
    j = [1:n]';
    b(i,j) = 0;
    I = [I;repmat(i,size(j,1),1)];
    J = [J;j];
end

i = [1:n]';
j = n;
b(i,j) = 0;
I = [I;i];
J = [J;repmat(j,size(i,1),1)];

A = grid_combinatorial_Laplacian(n,n,3,[I J]);
b = reshape(b,n^2,1);
X = A \ b;
X = full(reshape(X,n,n));
end