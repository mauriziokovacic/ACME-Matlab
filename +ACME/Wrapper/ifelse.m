function [out] = ifelse(condition,ifstat,elsestat)
if( condition )
    out = ifstat;
else
    out = elsestat;
end
end