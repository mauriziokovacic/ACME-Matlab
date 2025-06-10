function [P] = specular_pixel(A,B)
C = 2*A-B;
P = bresenham([A(1) C(1)], [A(2) C(2)]);
end