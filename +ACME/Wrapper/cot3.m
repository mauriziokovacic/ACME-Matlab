function [c] = cot3(A,B)
c = dot(A,B,2)./vecnorm3(cross(A,B,2));
end