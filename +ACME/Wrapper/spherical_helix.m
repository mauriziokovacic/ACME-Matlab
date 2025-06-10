function [P,E] = spherical_helix(t,c)
if (nargin<2)
    c = 0.1;
end
theta = t*2-1;
P     = [sqrt(1-theta.^2).* cos(theta/c),...
         sqrt(1-theta.^2).* sin(theta/c),...
         theta];
E     = poly2edge([(1:row(P)-1)',(2:row(P))']);
end