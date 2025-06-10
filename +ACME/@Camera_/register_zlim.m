function [obj] = register_zlim(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.ZLim = [obj.ZLim;get(h,'ZLim')];
end