function [Proxy] = Lloyd_proxy_fitting(B,N,A,Region)
Proxy  = cell(row(Region),2);
for r = 1 : row(Region)
    t          = Region{r};
    Proxy(r,1) = {mean(B(t,:))};
    Proxy(r,2) = {normr(mean(N(t,:)))};
end
end