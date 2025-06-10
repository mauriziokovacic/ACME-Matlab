function [h] = addSilouette(varargin)
parser = inputParser;
addParameter(parser,'Target',handle(gcf),@(x) isfigure(x)||isaxes(x)||ispatch(x));
addParameter(parser,'Width',           2,@(x) isscalar(x));
addParameter(parser,'CData',     [0 0 0],@(x) isvector(x)&&(numel(x)==3));
addParameter(parser,'Alpha',           1,@(x) isscalar(x));
parse(parser,varargin{:});

h = parser.Results.Target;
w = parser.Results.Width;
c = parser.Results.CData;
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
ax = CreateAxes3D(h,'PickableParts','none','HitTest','off');
for i = 1 : numel(s)
t  = patch(...
        'Faces',s(i).Faces,...
        'Vertices',s(i).Vertices,...
        'VertexNormals',s(i).VertexNormals,...
        'FaceLighting','none',...
        'LineWidth',w,...
        'FaceColor',c,...
        'FaceAlpha',a,...
        'EdgeColor',c,...
        'EdgeAlpha',a,...
        'HandleVisibility','off',...
        'HitTest','off',...
        'PickableParts','none');
addlistener(s(i),'Vertices','PostSet',@(varargin) set(t,'Vertices',s(i).Vertices));
end
uistack(ax,'down');
h = get_axes(h);
axes(h);
h = connect_axes([get_axes(h);ax], 'Position', 'OuterPosition');
end