function [tf] = ispoly(P,n)
if(nargin<2)
    n = [];
end
if(isempty(P))
    tf = false;
    return;
end
s  = polysides(P);
if(isempty(n))
    tf = any(s>4);
else
    tf = ~any(s~=n);
end
end