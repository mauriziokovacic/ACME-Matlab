function [obj] = set_path_to(obj,t)
if( obj.hasPath() )
param = linspace(0,1,100);
P = interp1(param,obj.CameraPosition,t,'spline');
T = interp1(param,obj.CameraTarget,t,'spline');
U = interp1(param,obj.CameraUpVector,t,'spline');
A = interp1(param,obj.CameraViewAngle,t,'spline');
obj = obj.setPosition(P);
obj = obj.setTarget(T);
obj = obj.setUpVector(U);
obj = obj.setViewAngle(A);
end
end