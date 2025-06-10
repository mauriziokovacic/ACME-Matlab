function [R] = aspectRatio(h)
viewport = h.Position;
R        = viewport(4)/viewport(3);
end