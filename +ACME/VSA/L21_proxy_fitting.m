function [Proxy] = L21_proxy_fitting(B,N,A,Region)
Proxy  = cell(row(Region),2);
for r = 1 : row(Region)
    t          = Region{r};
    area       = sum(A(t),1);
    Proxy(r,1) = {sum(A(t).*B(t,:),1) / area};
    Proxy(r,2) = {normr(sum(A(t).*N(t,:),1) / area)};
end
end