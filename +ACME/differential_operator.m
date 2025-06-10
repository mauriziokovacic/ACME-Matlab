function [Nabla ,Div, Delta] = differential_operator(P,T)
V = @(i) P(T(:,i),:);
n = row(P);
m = row(T);

N = cross(V(2)-V(1),V(3)-V(1),2);
A = vecnorm(N,2,2);
N = N./A;

G = Gradient(P,T,N,A);
D = Divergence(m,G,A);
Nabla = @(u) [G{1}*u, G{2}*u, G{3}*u];
Div   = @(g) D{1}*g(:,1) + D{2}*g(:,2) + D{3}*g(:,3);
Delta = Laplacian(G,D);
end

function [G] = Gradient(P,T,N,A)
V = @(i) P(T(:,i),:);
n = row(P);
m = row(T);

i = [];
j = [];
w = [];
for k = 1 : col(T)
    % opposite edge e_i indexes
    s = mod(k,3)+1;
    t = mod(k+1,3)+1;
    % vector N_f^e_i
    wk = cross(V(t)-V(s),N,2);
    % update the index listing
    i = [i, (1:m)'];
    j = [j, T(:,k)];
    w = [w; wk];
end
A = spdiags(1./A,0,m,m);
G = cell(col(P),1);
for k = 1 : col(P)
    G{k} = A*sparse(i,j,w(:,k),m,n);
end
end

function [D] = Divergence(m,G,A)
A = spdiags(A,0,m,m);
D = {G{1}'*A, G{2}'*A, G{3}'*A};
end

function [L] = Laplacian(G,D)
L = D{1}*G{1} + D{2}*G{2} + D{3}*G{3};
end