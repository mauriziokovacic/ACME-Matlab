function addMouseInteraction(varargin)
parser = inputParser;
addOptional( parser,'Figure',               handle(gcf),    @(x) isfigure(x));
addParameter(parser,'EventClick',           '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventGrab',            '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventRelease',         '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventMove',            '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventScroll',          '@(o,e) zoomCamera(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventLeftClick',       '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventLeftGrab',        '@(o,e) rotateCamera(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventLeftRelease',     '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventLeftGrabRelease', '@(o,e) rotateCamera()',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventRightClick',      '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventRightGrab',       '@(o,e) nop(o,e)');%,@(x) isstring(x)||ischar(x));
addParameter(parser,'EventRightRelease',    '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventRightGrabRelease','@(o,e) nop(o,e)');%,@(x) isstring(x)||ischar(x));
addParameter(parser,'EventWheelClick',      '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventWheelGrab',       '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventWheelRelease',    '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventWheelGrabRelease','@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventDoubleClick',     '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
parse(parser,varargin{:});
h = parser.Results.Figure;
event = InteractionEventCatcher(h);
mouse = MouseEventHandler(event);

name = fieldnames(parser.Results);
name(strcmpi(name,'Figure')) = [];
for i = 1 : numel(name)
    fun = parser.Results.(name{i});
    if(isstring(fun)||ischar(fun))
        fun = eval(fun);
    end
    addlistener(mouse,name{i},fun);
end
%cellfun(@(txt) addlistener(mouse,txt,eval(parser.Results.(txt))),name);
end


function rotateCamera(source,event)
persistent last;
if(nargin==0)
    last = [];
    return;
end
if(isempty(last))
    last = event.Position;
end
p    = event.Position;
dp   = last-p;
last = p;
arrayfun(@(ax) camorbit(ax,dp(1),dp(2),'coordsys','camera'),get_axes(getFigure(source)));
end

function zoomCamera(source,event)
s = 1-event.Data.VerticalScrollCount*0.1;
if( s <= 0 )
   return;
end
arrayfun(@(ax) camzoom(ax,s), get_axes(getFigure(source)));
% arrayfun(@(ax) campos(ax,ax.CameraPosition + 0.01 * (1-s) * (ax.CameraTarget - ax.CameraPosition)),...
%     get_axes(getFigure(source)));
end
