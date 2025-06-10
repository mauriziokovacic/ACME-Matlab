function [A] = poly_area(V,P)
[T,I] = poly2tri(P);
A     = triangle_area(V,T);
A     = accumarray(I,A(I),[row(P),1]);
end