function [dU, G] = Grad(P,T)
V = @(i) P(T(:,i),:);
n = row(P);
m = row(T);

N = cross(V(2)-V(1),V(3)-V(1),2);
A = vecnorm(N,2,2);
N = N./A;

i = [];
j = [];
w = [];
for k = 1 : col(P)
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
dU = @(u) [G{1}*u, G{2}*u, G{3}*u];
end


