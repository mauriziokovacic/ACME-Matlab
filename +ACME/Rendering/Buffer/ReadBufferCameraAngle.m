function [NData] = ReadBufferCameraAngle(h)
if(isfigure(h))
    ax = get_axes(h);
end
if( isaxes(h) )
    ax = h;
    h = ax.Parent;
end

p = get_patch(ax);
l = get_light(ax);

GraphicsSmoothing = h.GraphicsSmoothing;
Visible           = l.Visible;
FaceColor         = p.FaceColor;
FaceVertexCData   = p.FaceVertexCData;

h.GraphicsSmoothing = 'off';
l.Visible           = 'off';
p.FaceColor         = 'interp';
p.FaceVertexCData   = sum(get_camera_direction(ax).* p.VertexNormals,2);
% drawnow;

NData = getframe(h);
NData = NData.cdata;

h.GraphicsSmoothing = GraphicsSmoothing;
l.Visible           = Visible;
p.FaceColor         = FaceColor;
p.FaceVertexCData   = FaceVertexCData;
% drawnow;
end