function [V] = erase_zero(V,tol)
if(nargin<2)
    tol = 0;
end
V(abs(V)<=tol) = [];
end