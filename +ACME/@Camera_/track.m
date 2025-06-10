function [obj] = track(obj,P)
if( size(P,1) > 1 )
    P = mean(P,2);
end
obj = obj.setTarget(P);
end