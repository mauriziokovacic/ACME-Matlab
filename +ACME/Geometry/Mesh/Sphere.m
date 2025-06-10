function [P,N,T] = Sphere(C,r,Res)
if((nargin<3)||isempty(Res))
    Res = 20;
end
if((nargin<2)||isempty(r))
    r = 1;
end
if((nargin<1)||isempty(C))
    C = [0 0 0];
end
[x,y,z] = sphere(Res);
[T,P]   = surf2patch(x,y,z);
% T       = quad2tri(T);
N       = normr(P);
P       = C+r*P;
end