function [V] = matresize(V,scale,varargin)
expectedMethod = {'linear','nearest','next','previous','pchip','cubic','spline','makima'};
parser = inputParser;
addRequired( parser, 'M', @(m) dimension(m)>0 && isnumeric(m));
addRequired( parser, 'scale', @(s) numel(s)==ndims(V) && isnumeric(s));
addOptional( parser, 'method', 'linear', @(x) any(validatestring(x,expectedMethod)))
parse(parser,V,scale,varargin{:});
if( isempty(V) || prod(scale==size(V)))
    return;
end
method       = parser.Results.method;
CurrentScale = size(V);
CurrentScale(CurrentScale==1) = [];
scale(scale==1) = [];
X            = cell(numel(CurrentScale),1);
dim          = cellfun(@(s) linspace(0,1,s), num2cell(CurrentScale), 'UniformOutput', false);
[X{:}]       = ndgrid(dim{:});
F            = griddedInterpolant(X{:},V,method);
Xq           = cell(numel(scale),1);
dim          = cellfun(@(s) linspace(0,1,s), num2cell(scale), 'UniformOutput', false);
[Xq{:}]      = ndgrid(dim{:});
V            = F(Xq{:});
end