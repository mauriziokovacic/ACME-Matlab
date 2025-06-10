function [h] = ExampleCageDeformation(Mesh,Cage,W,i)

% f = CreateViewer3D('Name','Undeformed',...
%                    'NumberTitle','off',...
%                    'MenuBar', 'none',...
%                    'ToolBar','none',...
%                    'Units','normalized',...
%                    'Position',[0.2 0.2 0.2 0.3],...
%                    'right');
% Mesh.show();
% Cage.show('VertexNormals',Cage.Normal);

% CreateViewer3D('Name','Deformed Cage',...
%                'NumberTitle','off',...
%                'MenuBar', 'none',...
%                'ToolBar','none',...
%                'Units','normalized',...
%                'Position',[0 0.4 0.3333 0.5],...
%                'right');
% hcM = Mesh.show();
% hcC = Cage.show('VertexNormals',Cage.Normal);

% CreateViewer3D('Name','Deformed Weight',...
%                'NumberTitle','off',...
%                'MenuBar', 'none',...
%                'ToolBar','none',...
%                'Units','normalized',...
%                'Position',[0.3333 0.4 0.3333 0.5],...
%                'right');
% hwM = Mesh.show();
% hwC = Cage.show('VertexNormals',Cage.Normal);

% CreateViewer3D('Name','Both',...
%                'NumberTitle','off',...
%                'MenuBar', 'none',...
%                'ToolBar','none',...
%                'Units','normalized',...
%                'Position',[0.6666 0.4 0.3333 0.5],...
%                'right');
% hbM = Mesh.show();
% hbC = Cage.show('VertexNormals',Cage.Normal);
% cmap('king',256);
% caxis([0 10]);

h = connect_figures();

% frame = uicontrol( f,...
%                     'Style', 'slider',...
%                     'Units', 'normalized',...
%                     'Position', [0.1, 0.1, 0.8, 0.1],...
%                     'Min', 0,...
%                     'Max', 100,...
%                     'SliderStep', [0.01 0.1],...
%                     'Value', 1);

% addlistener( frame, 'ContinuousValueChange',...
%              @(o,e) deformCage(hcM,hcC,Cage.Vertex(i,:),W,i,(o.Value)/100,50) );

% addlistener( frame, 'ContinuousValueChange',...
%              @(o,e) deformWeight(hwM,hwC,W,i,(o.Value)/100,1) );

% addlistener( frame, 'ContinuousValueChange',...
%              @(o,e) deformWeight2(hwM,hwC,W,i,o.Value) );

% addlistener( frame, 'ContinuousValueChange',...
%              @(o,e) deformBoth(hbM,hbC,Cage.Vertex(i,:),W,i,(o.Value)/100));

makeVideo(Mesh,Cage,W,i);

end

function deformCage(m,c,p,w,i,t,factor)
dc              = c.VertexNormals(i,:) * distortion(t,50,10);
c.Vertices(i,:) = p+dc;
[p,n]           = MVC_deformation(c.Vertices,w,m.Faces);
m.Vertices      = p;
% m.VertexNormals = n;
end

function deformWeight(m,c,w,i,t,factor)
dw              = 1+distortion(t,0.5,30);
w(:,i)          = w(:,i)*dw;
[p,n]           = MVC_deformation(c.Vertices,w,m.Faces);
m.Vertices      = p;
% m.VertexNormals = n;
end

function deformWeight2(m,c,w,i,t)
persistent timeFcn;
if(isempty(timeFcn))
    timeFcn = TimeSignalFcn('Period',10,'Data',0.05*sin(linspace(0,pi,10)));
end
dw    = ones(1,col(w));
dw(i) = dw(i).* (1+timeFcn.fetch(t));
w     = w.*dw;
[p,n]           = MVC_deformation(c.Vertices,w,m.Faces);
m.Vertices      = p;
% m.VertexNormals = n;
end

function deformBoth(m,c,p,w,i,t)
dc              = c.VertexNormals(i,:) * distortion(t,50,10);
c.Vertices(i,:) = p+dc;
dw              = 1+distortion(t,0.5,30);
w(:,i)          = w(:,i)*dw;
[p,n]           = MVC_deformation(c.Vertices,w,m.Faces);
m.Vertices      = p;
% m.VertexNormals = n;
end

function meshDistance(m,a,b)
m.FaceColor = 'interp';
m.FaceVertexCData = distance(a.Vertices,b.Vertices);
end


function [d] = distortion(t,m,p)
if(nargin<3)
    p = 10;
end
d = 0.5*m*sin(p*pi*t);
end



function makeVideo(Mesh,Cage,W,i)
fig = CreateViewer3D('WindowState','maximized','right');
h = Mesh.show();
ax = h.Parent;
ax.CameraPosition  = [602.8869  117.6831  813.4596];
ax.CameraTarget    = [-0.0093   20.6612    7.5117];
ax.CameraUpVector  = [-0.0578    0.9954   -0.0766];
ax.CameraViewAngle = 7.8500;
l = get_light(ax);
arrayfun(@(h) camlight(h,'right'),l);

% timeFcn = TimeSignalFcn('Period',20,'Data',0.15*sin(linspace(0,pi,10)));
timeFcn = TimeSignalFcn('Period',30,'Data',0.15*gauss2mf(linspace(0,2,100),[0.1 0.3 0.3 0.5]));


nFrame = 200;
record = true;
if(record)
    vidObj = VideoWriter('Data/Boy/Breathing.mp4','MPEG-4');
    vidObj.Quality = 100;
    vidObj.open;
end

for f = 1 : nFrame
    dw = (0.9+timeFcn.fetch(f));
    w  = W;
    w(:,i) = w(:,i).*dw;
    
    [p,n]           = MVC_deformation(Cage.Vertex,w,Mesh.Face);
    h.Vertices      = p;
    h.VertexNormals = n;
    
    if(record)
        vidObj.writeVideo(getframe(fig));
        vidObj.writeVideo(getframe(fig));
        vidObj.writeVideo(getframe(fig));
    end
end

if(record)
    vidObj.close;
end

end
