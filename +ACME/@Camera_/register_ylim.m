function [obj] = register_ylim(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.YLim = [obj.YLim;get(h,'YLim')];
end