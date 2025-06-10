function [P] = poly2poly(P,side)
if(iscell(P))
    P = make_skinny(P);
    P = cell2mat(cellfun(@(p) helper(p,side),P,'UniformOutput',false));
else
    if(col(P)<side)
        P = helper(P,side);
    end
end
end

function [P] = helper(P,side)
    P = circrepeat(P,side-col(P),2);
end