function [DData] = grabDepthBuffer(h,near,far,MData)
if((nargin<4)||isempty(MData))
    MData = ReadBufferMask(h);
end
if(nargin<3)
    far = 1000;
end
if(nargin<2)
    near = 0.01;
end
if(isfigure(h))
    ax = get_axes(h);
end
if( isaxes(h) )
    ax = h;
    h = ax.Parent;
end
p = get_patch(ax);
X = campos(ax);
DData = repmat(1-normalize(clamp(distance(p.Vertices,X),near,far)),1,3);

GraphicsSmoothing = h.GraphicsSmoothing;
FaceLighting      = p.FaceLighting;
FaceColor         = p.FaceColor;
FaceVertexCData   = p.FaceVertexCData;

h.GraphicsSmoothing = 'off';
p.FaceLighting      = 'none';
p.FaceColor         = 'interp';
p.FaceVertexCData   = DData;

DData = getframe(h);
DData = MData.*double(DData.cdata(:,:,1))/255;

h.GraphicsSmoothing = GraphicsSmoothing;
p.FaceLighting      = FaceLighting;
p.FaceColor         = FaceColor;
p.FaceVertexCData   = FaceVertexCData;
end