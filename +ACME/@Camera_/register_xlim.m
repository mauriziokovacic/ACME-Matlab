function [obj] = register_xlim(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.XLim = [obj.XLim;get(h,'XLim')];
end