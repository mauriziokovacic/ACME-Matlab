function [L] = addLight(varargin)
expectedType = {'right','left','headlight'};
parser = inputParser;
parser.KeepUnmatched = true;
addOptional(parser,'Handle',handle(gca),@(x) isfigure(x)||isaxes(x)||ispatch(x));
addOptional(parser,'Type',expectedType{1},@(x) any(validatestring(x,expectedType)));
parse(parser,varargin{:});
h    = parser.Results.Handle;
type = parser.Results.Type;
if(isfigure(h)||isaxes(h))
    h = get_axes(h);
else
    if(ispatch(h))
        h = ancestor(h,'axes');
    else
        error('');
    end
end
L = camlight(h,type);

name  = fieldnames(parser.Unmatched);
if(~isempty(name))
    value = cellfun(@(txt) parser.Unmatched.(txt),name,'UniformOutput',false);
    set(L,name{:},value{:});
end
addlistener(h,'Projection',      'PostSet', @(varargin) camlight(L,type));
addlistener(h,'CameraPosition',  'PostSet', @(varargin) camlight(L,type));
addlistener(h,'CameraTarget',    'PostSet', @(varargin) camlight(L,type));
addlistener(h,'CameraUpVector',  'PostSet', @(varargin) camlight(L,type));
addlistener(h,'CameraViewAngle', 'PostSet', @(varargin) camlight(L,type));
end