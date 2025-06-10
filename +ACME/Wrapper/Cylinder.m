function [P,N,T,UV] = Cylinder(Side,Radius,Res)
if(nargin<3)
    Res = [8 16];
end
if(nargin<2)
    Radius = 1;
end
if(nargin<1)
    Side = 1;
end
[x,y,z] = cylinder(repmat(Radius,Res(1)+1,1),Res(2));
[T,P]   = surf2patch(x,y,z);
P(:,3)  = P(:,3)*Side;
N       = normr(P-[zeros(row(P),2) P(:,3)]);
UV      = [angle([1 0],N(:,1:2))/(2*pi) normalize(P(:,3))]; 
end