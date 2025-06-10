function [obj] = set_from(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj = obj.setPosition(get(h,'CameraPosition'));
obj = obj.setTarget(get(h,'CameraTarget'));
obj = obj.setUpVector(get(h,'CameraUpVector'));
obj = obj.setViewAngle(get(h,'CameraViewAngle'));
obj = obj.toggleClipping(get(h,'Clipping'));
obj = obj.setClippingStyle(get(h,'ClippingStyle'));
obj = obj.setXLim(get(h,'XLim'));
obj = obj.setYLim(get(h,'YLim'));
obj = obj.setZLim(get(h,'ZLim'));
end