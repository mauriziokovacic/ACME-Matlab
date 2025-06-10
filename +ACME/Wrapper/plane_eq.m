function [E] = plane_eq(P,N)
E = [N -dotN(P,N)];
end