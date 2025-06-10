function [C,I] = find_border(P,N,T,W)
table = {[0,0,0],[1,3,2],[2,1,3],[3,1,2],[3,2,1],[2,3,1],[1,2,3],[0,0,0]};
code  = @(i,j,k) base2dec(num2str([k j i] >= 0.5,'%u%u%u'),2)+1;
fetch = @(i,j,k) vertcat(table{code(i,j,k)});
tid = [];
wid = [];
ba  = [];
bb  = [];
[I,J,K] = tri2ind(T);
for w = 1 : size(W,2)
    F = full([W(I,w) W(J,w) W(K,w)]);
    X = fetch(F(:,1),F(:,2),F(:,3));  
    n = find(X(:,1)~=0);
    t = zeros(size(X,1),2);
    i = sub2ind(size(T),n,X(n,1));
    j = sub2ind(size(T),n,X(n,2));
    k = sub2ind(size(T),n,X(n,3));

    t(n,:) = [(0.5-F(j))./(F(i)-F(j)) , (0.5-F(k))./(F(i)-F(k))];

    tid = [tid;n];
    wid = [wid;repmat(w,numel(n),1)];

    z = zeros(numel(n),3);
    z(sub2ind(size(z),(1:numel(n))',X(n,1))) = t(n,1);
    z(sub2ind(size(z),(1:numel(n))',X(n,2))) = 1-t(n,1);
    ba = [ba;z];

    z = zeros(numel(n),3);
    z(sub2ind(size(z),(1:numel(n))',X(n,1))) = t(n,2);
    z(sub2ind(size(z),(1:numel(n))',X(n,3))) = 1-t(n,2);
    bb = [bb;z];

end

k = zeros(size(P,1),1);
data = [ba(:,1);ba(:,2);ba(:,3);bb(:,1);bb(:,2);bb(:,3)];
for i = 1 : size(P,1)
    j = find([I(tid);J(tid);K(tid)] == i);
    if( ~isempty(j) )
        k(i) = max(data(j));
    end
end
L = cotangent_Laplacian(P,T);
A = barycentric_area(P,T);
t = diffusion_time(1,mean_edge_length(P,T));
u = linear_problem(A+t*L,k);
gu = compute_gradient(P,T,u);
du = compute_divergence(P,T,gu);
uu = linear_problem(L,du);
I = normalize(uu);


C = extract_curve(from_barycentric(P,T,tid,ba),...
                  from_barycentric(P,T,tid,bb),...
                  from_barycentric(N,T,tid,ba),...
                  tid,...
                  from_barycentric(W,T,tid,ba),...
                  wid);
              
for w = 1 : size(W,2)
    if( ~isempty(C{w}) )
        C{w}.N = find_symmetry(C{w}.P,C{w}.N,C{w}.E);
%         C{w}.N = find_symmetry(C{w}.P,normr(C{w}.P-C{w}.C),C{w}.E);
    end
end

end