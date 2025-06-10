function [V] = clamp3(A,min,max)
V = [clamp(A(:,1),min(1),max(1)), clamp(A(:,2),min(2),max(2)), clamp(A(:,3),min(3),max(3))];
end