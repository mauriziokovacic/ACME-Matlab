function [obj] = register_viewangle(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.CameraViewAngle = [obj.CameraViewAngle;get(h,'CameraViewAngle')];
end