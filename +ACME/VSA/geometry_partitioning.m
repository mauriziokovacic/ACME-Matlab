function [Region,E] = geometry_partitioning(B,N,A,Adj,Proxy,Region)
visited = false(row(B),1);
Q = [];
for r = 1 : row(Region)
    t          = Region{r};
    E          = L21_Energy(B(t,:),N(t,:),A(t),Proxy(r,:));
    [~,i]      = min(E);
    t          = t(i);
    Region{r}  = t;
    visited(t) = true;
    n          = Adj{t};
    Q          = [Q;L21_Energy(B(n,:),N(n,:),A(n),Proxy(r,:)) repmat(r,numel(n),1) n];
end
Q = sortrows(Q,[1 2 3],'ascend');

E = zeros(row(B),1);
while(~isempty(Q))
    entry  = Q(1,:);
    Q(1,:) = [];
    E = entry(1);
    r = entry(2);
    t = entry(3);
    if( visited(t) )
        continue;
    end
    E(t)       = E;
    visited(t) = true;
    Region{r}  = [Region{r};t];
    n = Adj{t};
    Q = [Q;L21_Energy(B(n,:),N(n,:),A(n),Proxy(r,:)) repmat(r,numel(n),1) n];
    Q = sortrows(Q,[1 2 3],'ascend');
end
end