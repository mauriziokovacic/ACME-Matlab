function [D] = get_camera_direction(h)
h = get_axes(h);
D = normr(h.CameraTarget - h.CameraPosition);
end