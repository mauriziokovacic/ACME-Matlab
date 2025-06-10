function [ds] = specular_direction(dn,di)
ds = (2.*dotN(dn,di).*dn-di);
end