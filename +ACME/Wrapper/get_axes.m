function [ax] = get_axes(h)
ax = h(isaxes(h));
h  = get(h(isfigure(h)),'Children');
if(iscell(h))
    h = cellfun(@(c) c(isaxes(c)),h);
else
    h = h(isaxes(h));
end
ax = [ax;h];
end