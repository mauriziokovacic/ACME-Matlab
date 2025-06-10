function [M,T] = xedge(T,iter)
i = 1; j = 2;
scheme = struct('E',[i i; i j; i j; j j],'T',2);
[M,T] = xmesh(T,scheme,iter);
end