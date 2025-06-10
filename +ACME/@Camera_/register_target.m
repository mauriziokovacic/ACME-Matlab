function [obj] = register_target(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.CameraTarget = [obj.CameraTarget;get(h,'CameraTarget')];
end