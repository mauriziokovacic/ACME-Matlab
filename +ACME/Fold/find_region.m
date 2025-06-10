function [R] = find_region(P,T,W)
[i,j] = find(W>=0.5);
R = sparse(i,j,1,row(P),col(W));

A = Adjacency(P,T,'comb');
[i,j] = find(A);
A = cell(row(P),1);
for n = 1 : numel(i)
    A{i(n)} = [A{i(n)};j(n)];
end

K = [];
I = [];

for r = 1 : col(R)
    i = find(R(:,r));
    visited = false(row(P),1);
    while(~isempty(i))
        k = [];
        Q = i(1);
        while(~isempty(Q))
            v    = Q(1);
            Q(1) = [];
            if( visited(v) )
                continue;
            end
            k          = [k;v];
            visited(v) = true;
            j          = A{v};
            j          = intersect(j,i);
            Q          = [Q;j];
        end
        K = [K sparse(k,1,1,row(P),1)];
        I = [I;r];
        i = setdiff(i,k);
    end
end
R   = struct('I',[K sparse(find(sum(K,2)<1),1,1,row(P),1)],'W',[I;0]);
end