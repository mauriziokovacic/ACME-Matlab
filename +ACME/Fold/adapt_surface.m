function [P,N,UV,T,W,E] = adapt_surface(P,N,UV,T,W,F,iso_target)
tri   = {[],...
         [1 5 4; 2 4 5; 2 3 4],...
         [2 5 4; 3 4 5; 3 1 4],...
         [1 2 4; 2 5 4; 3 4 5],...
         [3 5 4; 1 4 5; 1 2 4],...
         [3 1 4; 1 5 4; 2 4 5],...
         [2 3 4; 3 5 4; 1 4 5],...
         []};
tex   = @(c,v) cell2mat(cellfun(@(a,b) a(b),num2cell(v,2),tri(c)','UniformOutput',false) );
     
table = {[0,0,0],[1,3,2],[2,1,3],[3,1,2],[3,2,1],[2,3,1],[1,2,3],[0,0,0]};
code  = @(i,j,k) base2dec(num2str([k j i] >= iso_target,'%u%u%u'),2)+1;
fetch = @(c) vertcat(table{c});

if( nargin < 6 )
    iso_target = 0.5;
end

E = [];
for f = 1 : col(F)
[P,T,N,UV,W,F] = mesh2soup(P,T,N,UV,W,F);
[I,J,K]     = tri2ind(T);

Fi = full([F(I,f) F(J,f) F(K,f)]);
Xc = code(Fi(:,1),Fi(:,2),Fi(:,3));
X  = fetch(Xc);  
n  = find(X(:,1)~=0);

if( ~isempty(n) )
    s = [numel(n) 3];
    A = zeros(s);
    B = zeros(s);

    t = zeros(size(X,1),2);
    i = sub2ind(size(T),n,X(n,1));
    j = sub2ind(size(T),n,X(n,2));
    k = sub2ind(size(T),n,X(n,3));
    t(n,:) = [(iso_target-Fi(j))./(Fi(i)-Fi(j)) , (iso_target-Fi(k))./(Fi(i)-Fi(k))];

    A(sub2ind(s,(1:numel(n))',X(n,1))) = t(n,1);
    A(sub2ind(s,(1:numel(n))',X(n,2))) = 1-t(n,1);
    B(sub2ind(s,(1:numel(n))',X(n,1))) = t(n,2);
    B(sub2ind(s,(1:numel(n))',X(n,3))) = 1-t(n,2);

    Pa = from_barycentric( P,T,n,A);
    Pb = from_barycentric( P,T,n,B);
    k = find(vecnorm3(Pa-Pb)>0);
    
    A = A(k,:);
    B = B(k,:);
    n = n(k);
    
    P  = [ P;from_barycentric( P,T,n,A);from_barycentric( P,T,n,B)];
    N  = [ N;from_barycentric( N,T,n,A);from_barycentric( N,T,n,B)];
    UV = [UV;from_barycentric(UV,T,n,A);from_barycentric(UV,T,n,B)];
    W  = [ W;from_barycentric( W,T,n,A);from_barycentric( W,T,n,B)];
    F  = [ F;from_barycentric( F,T,n,A);from_barycentric( F,T,n,B)];

    i = row(P)-2*numel(n)+1;
    j = row(P)-1*numel(n)+1;
    E  = [E;(i:(j-1))' (j:row(P))'];
    
    T  = [ T; tex(Xc(n),[T(n,:) (i:(j-1))' (j:row(P))'] )];
    T(n,:) = [];
end

end

% [P,N,UV,T,W,E] = soup2mesh(P,N,UV,T,W,E);
[P,T,I,J] = soup2mesh(P,T);
N  = N(I,:);
UV = UV(I,:);
W  = W(I,:);
E  = J(E);
end