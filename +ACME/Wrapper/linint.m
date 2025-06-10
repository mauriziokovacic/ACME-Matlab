function [C] = linint(A,B,t)
C = (1-t) .* A + t .* B;
end