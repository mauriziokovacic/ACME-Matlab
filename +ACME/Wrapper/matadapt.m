function [M] = matadapt(M,Siz)
tf = issparse(M);
m  = row(M);
n  = col(M);
dm = Siz(1)-m;
dn = Siz(2)-n;
M = [M(1:clamp(m+dm,0,m),1:clamp(n+dn,0,n)) sparse(clamp(m+dm,0,m),dn); sparse(dm,n+dn)];
if(~tf)
    M = full(M);
end
end