function [obj] = register_position(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.CameraPosition = [obj.CameraPosition;get(h,'CameraPosition')];
end