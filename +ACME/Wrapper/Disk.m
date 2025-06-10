function [P,N,T] = Disk(Side,Res,hole)
if(nargin<3)
    hole = false;
end
if(nargin<2)
    Res = [8 8];
end
if(nargin<1)
    Side = 1;
end
if(hole)
    r = linspace(0,Side,Res(1)+2);
    r(1) = [];
else
    r = linspace(0,Side,Res(1)+1);
end
t     = linspace(0,2*pi,Res(2)+1)';
r     = repmat(r,Res(2)+1,1);
t     = repmat(t,1,Res(1)+1);
[x,y] = pol2cart(t,r);
[T,P] = surf2patch(x,y,zeros(size(x)));
N     = repmat([0 0 1],row(P),1);
end