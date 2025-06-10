function [P, N, T] = OctaSphere(n)
if(nargin == 0)
    n = 16;
end
if(n<3)
    n = 3;
end
if(mod(n,2)==0)
    n = n+1;
end
P = Octahedron();
g = cell(col(P),1);
for i = 1 : col(P)
    g{i} = matresize([
        P(6, i), P(3, i), P(6, i);...
        P(4, i), P(1, i), P(2, i);...
        P(6, i), P(5, i), P(6, i);...
           ], [n n]);
end
%g = cat(3, g{:});
%g = matresize(g, [n n n]);
[T,P]   = surf2patch(g{:});
P       = normr(P);
N       = P;
end