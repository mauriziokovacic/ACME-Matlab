function [S] = ReadShadowMap(h)
ax = get_axes(h);
c = get(ax, 'CameraPosition');
% l = get_light(ax);
% set(ax,'CameraPosition',l.Position);
cam = Camera().from_axes(ax);
S = ReadBufferDepth(h);
set(ax,'CameraPosition',c);
p = get_patch(ax);
[uv,d] = cam.project(p.Vertices);
S = shadow_map(uv,d,S);
end