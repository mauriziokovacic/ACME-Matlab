function [P] = poly2compact(P)
if(iscell(P))
    n = polysides(P);
    if(any(n~=n(1)))
        return;
    end
    P = poly2equal(P);
end
end