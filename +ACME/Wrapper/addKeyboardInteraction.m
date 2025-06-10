function addKeyboardInteraction(varargin)
parser = inputParser;
addOptional( parser,'Figure',                handle(gcf),@(x) isfigure(x));
addParameter(parser,'EventKeyPress',   '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
addParameter(parser,'EventKeyRelease', '@(o,e) nop(o,e)',@(x) isstring(x)||ischar(x));
parse(parser,varargin{:});
h     = parser.Results.Figure;
event = InteractionEventCatcher(h);
key   = KeyEventHandler(event);
name  = fieldnames(parser.Results);
name(strcmpi(name,'Figure')) = [];
cellfun(@(txt) addlistener(key,txt,eval(parser.Results.(txt))),name);
end