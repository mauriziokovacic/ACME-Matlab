function [obj] = register_upvector(obj,h)
if( isfigure(h) )
    h = get(h,'CurrentAxes');
end
obj.CameraUpVector = [obj.CameraUpVector;get(h,'CameraUpVector')];
end