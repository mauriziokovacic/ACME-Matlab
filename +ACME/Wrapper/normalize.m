function [V] = normalize(U,Umin,Umax)
if(nargin<3)
    Umax = max(U);
end
if(nargin<2)
    Umin = min(U);
end
if(Umax==Umin)
    V = zeros(size(U));
else
    V = (U-Umin)./(Umax-Umin);
end
end