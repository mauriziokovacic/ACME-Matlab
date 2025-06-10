function [P] = poly2equal(P)
P = poly2poly(P,max(polysides(P)));
end