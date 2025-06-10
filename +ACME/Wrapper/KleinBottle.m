function [P,T] = KleinBottle(Side,Res)
if((nargin<2)||isempty(Res))
    Res = 50;
end
if((nargin<1)||isempty(Side))
    Side = 50;
end
a      = 0.2;                           % the diameter of the small tube
c      = 0.6;                           % the diameter of the bulb
t1     = linspace(pi/4,5*pi/4,Res+1);   % parameter along the tube
t2     = linspace(5*pi/4,9*pi/4,Res+1); % angle around the tube
u      = linspace(pi/2,5*pi/2,Side+1);
[X,Z1] = meshgrid(t1,u);
[Y,Z2] = meshgrid(t2,u);

% The handle
len     = sqrt(sin(X).^2 + cos(2*X).^2);
x       = c*ones(size(X)).*(cos(X).*sin(X) ...
          - 0.5*ones(size(X))+a*sin(Z1).*sin(X)./len);
y       = a*c*cos(Z1).*ones(size(X));
z       = ones(size(X)).*cos(X) + a*c*sin(Z1).*cos(2*X)./len;
[T1,P1] = surf2patch(x,y,z);

% The bulb
r = sin(Y) .* cos(Y) - (a + 1/2) * ones(size(Y));
x = c * sin(Z2) .* r;
y = - c * cos(Z2) .* r;
z = ones(size(Y)) .* cos(Y);
[T2,P2] = surf2patch(x,y,z);

P = [P1;P2];
T = [T1;T2+row(P1)];
[P,T] = soup2mesh(P,zeros(size(P)),zeros(row(P),2),T);
end