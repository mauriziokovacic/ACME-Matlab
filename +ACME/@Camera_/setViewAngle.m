function [obj] = setViewAngle(obj,value)
value = clamp(value,0,179.999);
obj.CameraViewAngle = value;
end