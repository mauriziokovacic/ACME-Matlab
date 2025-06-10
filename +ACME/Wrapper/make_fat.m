function [M] = make_fat(M)
if(isskinny(M))
    M = M';
end
end