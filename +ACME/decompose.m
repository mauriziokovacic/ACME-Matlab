function [U,S,V] = decompose(M)
syms lambda
MtM    = transpose(M)*M;
lambda = (solve(det(MtM-lambda*eye(3))==0,lambda)).^2;
v1     = Gram(MtM-lambda(1)*eye(3));
v2     = Gram(MtM-lambda(2)*eye(3));
v3     = Gram(MtM-lambda(3)*eye(3));
V      = [v1(:,1), v2(:,1), v3(:,1)];
V      = V./[sqrt(transpose(V(:,1))*V(:,1)),...
             sqrt(transpose(V(:,2))*V(:,2)),...
             sqrt(transpose(V(:,3))*V(:,3))];
S = sqrt(diag(lambda));
U = (M*V)*inv(S);
end

