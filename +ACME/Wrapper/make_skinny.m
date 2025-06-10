function [M] = make_skinny(M)
if(isfat(M))
    M = M';
end
end