function [f] = function_angle( A0, At )
c = 0.3;
m = 0-c;
M = 1+c;
f = 1-(clamp( (At+1) ./ (A0+1), m, M )-m)./(M-m);
f( ~isfinite(f) ) = 0;
end