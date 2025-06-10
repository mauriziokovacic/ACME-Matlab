function [S] = polysides(P)
if(iscell(P))
    S = cellfun(@numel,P);
else
    S = col(P);
end
end