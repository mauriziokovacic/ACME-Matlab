function [P,T] = KleinFigure8(r,Res)
if((nargin<2)||isempty(Res))
    Res = 50;
end
if((nargin<1)||isempty(r))
    r = 3;
end
[theta,nu] = meshgrid(linspace(0,2*pi,Res+1));
x = (r+cos(theta/2) .* sin(nu) - sin(theta/2).*sin(2*nu)) .* cos(theta);
y = (r+cos(theta/2) .* sin(nu) - sin(theta/2).*sin(2*nu)) .* sin(theta);
z = sin(theta/2) .* sin(nu) + cos(theta/2).*sin(2*nu);
[T,P] = surf2patch(x,y,z);
end