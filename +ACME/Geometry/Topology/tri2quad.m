function [Q] = tri2quad(T)
Q = poly2poly(T,4);
end