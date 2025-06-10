function [h] = addShadow(varargin)
parser = inputParser;
addParameter(parser,'Target',           handle(gcf),@(x) isfigure(x)||isaxes(x)||ispatch(x));
addParameter(parser,'Light', get_light(handle(gca)),@(x) islight(x));
addParameter(parser,'CData',          [0.5 0.5 0.5],@(x) is3DVec(x));
addParameter(parser,'Ground',               [0 0 1],@(x) is3DVec(x));
addParameter(parser,'Alpha',                      1,@(x) isscalar(x));
parse(parser,varargin{:});

h = parser.Results.Target;
l = parser.Results.Light;
c = parser.Results.CData;
g = parser.Results.Ground;
a = parser.Results.Alpha;

if(ispatch(h))
    s = h;
    h = ancestor(h,'figure');
else
    if(isaxes(h))
        s = get_patch(h);
        h = ancestor(h,'figure');
    else
        s = get_patch(h);
    end
end

g = [g min(point_plane_distance([0 0 0], g, s.Vertices))];

ax = CreateAxes3D(h);
for i = 1 : numel(s)
    P  = transformPoint(g,s(i).Vertices,l.Position);
    a = ones(row(P),1);%normalize(distance(P,l.Position));
    t  = patch(...
        'Faces',s(i).Faces,...
        'Vertices',P,...
        'VertexNormals',repmat(g(1:3),row(P),1),...
        'FaceLighting','none',...
        'FaceColor',c,...
        'FaceAlpha','interp',...
        'FaceVertexAlphaData',a,...
        'EdgeColor','none',...
        'AmbientStrength',1,...    
        'DiffuseStrength',0,...
        'SpecularStrength',0,...
        'HandleVisibility','off');
addlistener(s(i),'Vertices','PostSet',@(varargin) set(t,'Vertices',transformPoint(g,s(i).Vertices,l.Position)));
addlistener(l,'Position','PostSet',@(varargin) set(t,'Vertices',transformPoint(g,s(i).Vertices,l.Position)));
end
uistack(ax,'down');
h = connect_axes([get_axes(h);ax]);
end

function [P] = transformPoint(G,P,L)
L = [L 1];
d = G * L';
M = d*eye(4) - L'*G;
P = [P ones(row(P),1)]*M';
P = bsxfun(@rdivide,P(:,1:3),P(:,4));
end