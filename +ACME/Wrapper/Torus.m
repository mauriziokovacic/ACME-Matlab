function [P,N,T] = Torus(Radius,Width,Res)
if((nargin<3)||isempty(Res))
    Res = 20;
end
if((nargin<2)||isempty(Width))
    Width = 0.5;
end
if((nargin<1)||isempty(Radius))
    Radius = 1;
end
[Phi,Theta] = meshgrid(linspace(0,2*pi,Res),linspace(0,2*pi,Res)); 
x = (Radius + Width * cos(Theta)) .* cos(Phi);
y = (Radius + Width * cos(Theta)) .* sin(Phi);
z = Width * sin(Theta);
[T,P]   = surf2patch(x,y,z);
t       = quad2tri(T);
N       = vertex_normal(P,t);
end