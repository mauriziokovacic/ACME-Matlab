function [P,T,U,A,J,C,S,X,Y,Z] = fetchData(obj,t)
if( obj.hasPathTime() )
    param = linspace(0,1,numel(obj.PathTime));
    t = interp1(param,obj.PathTime,t,'spline');
end
if( obj.Path > 1 )
    param = linspace(0,1,obj.Path);
    P = interp1(param,obj.CameraPosition,t,'spline');
    T = interp1(param,obj.CameraTarget,t,'spline');
    U = interp1(param,obj.CameraUpVector,t,'spline');
    A = interp1(param,obj.CameraViewAngle,t,'spline');
    X = interp1(param,obj.XLim,t,'spline');
    Y = interp1(param,obj.YLim,t,'spline');
    Z = interp1(param,obj.ZLim,t,'spline');
else
    P = obj.CameraPosition;
    T = obj.CameraTarget;
    U = obj.CameraUpVector;
    A = obj.CameraViewAngle;
    X = obj.XLim;
    Y = obj.YLim;
    Z = obj.ZLim;
end

J = obj.Projection;
C = obj.Clipping;
S = obj.ClippingStyle;
end