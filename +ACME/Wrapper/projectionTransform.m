function [P] = projectionTransform(ax, aspectRatio )
fov    = ax.CameraViewAngle;
tanfov = tand(fov/2);
n      = 0.1;
f      = 10;
r      = tanfov * aspectRatio * n;
l      = -r;
t      = tanfov * n;
b      = -t;
P      = [2*n/(r-l), 0,          (r+l)/(r-l),  0; ...
          0,         2*n/(t-b),  (t+b)/(t-b),  0; ...
          0,         0,         -(f+n)/(f-n), -2*f*n/(f-n); ...
          0,         0,         -1,            0];
      
% f = 1000;
% n = 0.0001;
% P = [1./(tan((fov/2)* (pi/180))), 0, 0, 0;...
%      0, 1./(tan((fov/2)* (pi/180))), 0, 0;...
%      0, 0, -(f/(f-n)), -((f*n)/(f-n));...
%      0, 0, -1, 0];
end
