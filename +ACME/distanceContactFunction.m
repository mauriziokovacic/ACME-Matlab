function [f] = distanceContactFunction(D0,Dt)
f = 1 - Dt ./ D0;
f(~isfinite(f)) = 0;
f(f>1)          = 0;
f = clamp(f,0,1);
end