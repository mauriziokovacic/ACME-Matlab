function [P] = curve2pixel(C)
P = [];
for i = 2 : row(C)
    P = [P;bresenham(C(i-1:i,1),C(i-1:i,2))];
end
P = removeConsecutive(P);
end