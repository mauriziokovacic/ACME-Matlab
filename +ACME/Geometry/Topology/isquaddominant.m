function [tf] = isquaddominant(P)
n  = polysides(P);
tf = any(n==4)&&(~any([n<3 n>4]));
end