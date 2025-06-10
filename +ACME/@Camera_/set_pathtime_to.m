function [obj] = set_pathtime_to(obj,t)
if( obj.hasPathTime() )
    T = linspace(0,1,100);
    t = interp1(T,obj.PathTime,t,'spline');
    obj = obj.set_path_to(t);
else
    obj = set_path_to(t);
end
end