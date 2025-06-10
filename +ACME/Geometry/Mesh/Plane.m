function [P,N,T,UV] = Plane(Side,Res)
if((nargin<2)||isempty(Res))
    Res = 2;
end
if(numel(Res)==1)
    Res = [Res Res];
else
    Res = Res(1:2);
end
if((nargin<1)||isempty(Side))
    Side = 1;
end
if(numel(Side)==1)
    Side = [Side Side];
else
    Side = Side(1:2);
end
[x,y]  = meshgrid(linspace(-Side(1)/2,Side(1)/2,Res(1)+1),...
                  linspace(-Side(2)/2,Side(2)/2,Res(2)+1));
[T,P]  = surf2patch(x,y,zeros(size(x)));
% T      = quad2tri(T);
N      = repmat([0 0 1],row(P),1);
UV     = [normalize(P(:,1)) normalize(P(:,2))];
end