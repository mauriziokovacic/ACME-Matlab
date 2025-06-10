function [M,T] = xtri2quad(T)
i = 1; j = 2; k = 3;
scheme = struct('E',[i i i i i i; i i i j j j; i i j j k k; i i i k k k;...
          j j j j j j; j j j k k k; i i j j k k; j j j i i i;...
          k k k k k k; k k k i i i; i i j j k k; k k k j j j],'T',4);
iter = 1;
if(isquad(T))
    iter=0;
end
[M,T] = xmesh(T,scheme,iter);
end