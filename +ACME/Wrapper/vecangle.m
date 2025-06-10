function [theta] = vecangle(A,B)
theta = acos(clamp(dotN(normr(A),normr(B)),-1,1));
end