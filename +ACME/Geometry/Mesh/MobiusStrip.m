function [P,T] = MobiusStrip(Side,Res)
if((nargin<2)||isempty(Res))
    Res = 10;
end
if((nargin<1)||isempty(Side))
    Side = 50;
end
u = linspace(0,2*pi,Side+1);
v = linspace(-0.5,0.5,Res+1);
[u,v] = meshgrid(u,v);  
x = (1+v.*cos(u/2)).*cos(u);
y = (1+v.*cos(u/2)).*sin(u);
z = v.*sin(u/2);
[T,P]   = surf2patch(x,y,z);
end