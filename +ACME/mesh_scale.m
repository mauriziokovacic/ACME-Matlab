function [s] = mesh_scale(P)
[m,M] = bounding_box(P);
s = vecnorm3(m-M);
end