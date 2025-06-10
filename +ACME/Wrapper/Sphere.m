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
if(numel(Res)==1)
    Res=[Res Res];
end

theta         = (-Res(1):2:Res(1))/Res(1)*pi;
phi           = (-Res(2):2:Res(2))'/Res(2)*pi/2;
cosphi        = cos(phi);
cosphi(1)     = 0;
cosphi(end)   = 0;
sintheta      = sin(theta);
sintheta(1)   = 0;
sintheta(end) = 0;
x             = cosphi*cos(theta);
y             = cosphi*sintheta;
z             = sin(phi)*ones(1,Res(1)+1);

[T,P]   = surf2patch(x,y,z);
N       = normr(P);
P       = C+r.*P;
end