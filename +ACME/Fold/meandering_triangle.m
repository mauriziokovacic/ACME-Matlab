function [C] = meandering_triangle(T,F,iso_target)
if( nargin < 3 )
    iso_target = 0.5;
end
table   = {[0,0,0],[1,3,2],[2,1,3],[3,1,2],[3,2,1],[2,3,1],[1,2,3],[0,0,0]};
code    = @(v) bi2de(v >= iso_target)+1;
fetch   = @(v) vertcat(table{code(v)});
[I,J,K] = tri2ind(T);
C       = cell(col(F),1);
parfor f = 1 : col(F)
    Fi = full([F(I,f) F(J,f) F(K,f)]);
    X  = fetch(Fi);  
    n  = find(X(:,1)~=0);
    if( ~isempty(n) )
        s   = [numel(n) 3];
        c   = struct();
        c.A = zeros(s);
        c.B = zeros(s);
        c.T = n;
        t   = zeros(row(X),2);
        i   = sub2ind(size(T),n,X(n,1));
        j   = sub2ind(size(T),n,X(n,2));
        k   = sub2ind(size(T),n,X(n,3));
        t(n,:) = [(iso_target-Fi(j))./(Fi(i)-Fi(j)) ,...
                  (iso_target-Fi(k))./(Fi(i)-Fi(k))];
        
        c.A(sub2ind(s,(1:numel(n))',X(n,1))) = t(n,1);
        c.A(sub2ind(s,(1:numel(n))',X(n,2))) = 1-t(n,1);
        c.A(c.A<0.01) = 0;
        c.A = c.A ./ sum(c.A,2);
        
        c.B(sub2ind(s,(1:numel(n))',X(n,1))) = t(n,2);
        c.B(sub2ind(s,(1:numel(n))',X(n,3))) = 1-t(n,2);
        c.B(c.B<0.01) = 0;
        c.B = c.B ./ sum(c.B,2);
        
        i = find(sum((c.A-c.B).^2,2)<0.0001);
        c.A(i,:) = [];
        c.B(i,:) = [];
        c.T(i,:) = [];
        C{f}     = c;
    end
end
end