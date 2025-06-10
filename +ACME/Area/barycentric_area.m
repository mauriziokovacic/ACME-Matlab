function [ A ] = barycentric_area( P, T )
n     = row(P);
[~,J] = poly2lin(T);
A     = poly_area(P,T) ./ polysides(T);
A     = spdiags(A(J),0,n,n);
end