function [P] = equilateral_polygon(n,r)
if((nargin<2)||isempty(r))
    r = 1;
end
t = linspace(0,2*pi,n+1)';
t = t(1:end-1);
P = [r*cos(t) r*sin(t)];
end