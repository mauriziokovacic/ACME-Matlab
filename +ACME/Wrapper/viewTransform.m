function [V] = viewTransform(ax)
s        = 1./diff([ax.XLim;ax.YLim;ax.ZLim],1,2)';
[az,el]  = view(ax);
phi      = ax.CameraViewAngle;
V        = viewmtx(az,el,phi);
offset   = (ax.CameraPosition-ax.CameraTarget).*s + [1/2 1/2 1/2];
offset   = V*[offset 1]';
V(1:3,4) = -offset(1:3);
end