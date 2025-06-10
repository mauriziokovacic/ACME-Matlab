function [out] = bokeh(aperture,n)
if(nargin<1)
    aperture = 5;
end
if(nargin<2)
    n = 50;
end
ax = handle(gca);
E = ax.CameraPosition;
T = ax.CameraTarget;
U = normr(ax.CameraUpVector);
D = normr(T - E);
R = normr(cross(U,D,2));

frame = cell(n,1);
for i = 1 : n
B = aperture * (R * cos(i * 2 * pi / n) + U * sin(i * 2 * pi / n));
ax.CameraPosition = E+B;
ax.CameraUpVector = U;
ax.CameraTarget = T;
h = getframe(ax.Parent);
frame{i} = h.cdata;
end
s = min(cell2mat(cellfun(@(c) size(c),frame,'UniformOutput',false)));
out = zeros(s);
for i = 1 : n
out = out + double(frame{i});
end
out = out / n;
out = uint8(out);
end