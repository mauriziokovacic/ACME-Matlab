function [V] = discretize_value(V,n)
if(nargin<2)
    n = 10;
end
flag = issparse(V);
V = full(V);
X = uniquetol(V,0.0001);
a = minimum(X);
b = maximum(X);
V = interp1(linspace(a,b,n),...
            linspace(a,b,n),V,'nearest');
if(flag)
    V = sparse(V);
end
end