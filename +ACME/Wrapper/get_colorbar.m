function [c] = get_colorbar(h)
c  = h(iscolorbar(h));
h  = get(h(isfigure(h)),'Children');
c  = [c;h(iscolorbar(h))];
end