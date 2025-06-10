function [P,N,T] = Tetrahedron(Area)
if(nargin<1)
    Area = 1;
end
if(~isscalar(Area)||(Area<0))
    error('Area input is invalid.');
end
P = [ 1/3 * sqrt(3) * Area,          0,                    0;...
     -1/6 * sqrt(3) * Area, 1/2 * Area,                    0;...
     -1/6 * sqrt(3) * Area,-1/2 * Area,                    0;...
                         0,          0, 1/3 * sqrt(6) * Area];
P = P-mean(P,1);
T = polyflip([1 2 3; 1 3 4; 1 4 2; 3 2 4]);
N = vertex_normal(P,T);
end