function [It,In,varargout] = submesh(varargin)
% SUBMESH  Given a set of a mesh nodes/polygons indices, create the
% indices for constructing a submesh.
%
%   [It,In,T] = SUBMESH(T,index) creates the polygons indices It, the nodes
%   indices In and the new topology from given the topology polygons T and
%   a set of indices relative to T.
%
%   [It,In,T] = SUBMESH(...,Name,Value) creates the new topology data and
%   specifies one or more SUBMESH properties using name-value pair
%   arguments. You can specify the extraction type such as 'node' or
%   'topology', and the number of nodes . For example 'Type','node' extracts all the polygons
%   incident the specified nodes.
%
expectedType = {'node','topology'};
parser = inputParser;
addRequired( parser,'Topology',                @(x) (isnumeric(x)||iscell(x))&&(~isempty(x)));
addRequired( parser,'Index',                   @(x) isvector(x));
addParameter(parser,'Type',    expectedType{1},@(x) any(validatestring(x,expectedType)));
parse(parser,varargin{:});
% Gather input
T    = parser.Results.Topology;
ind  = parser.Results.Index;
type = lower(parser.Results.Type);
% Equalize topology
TT = poly2equal(T);
n  = max(TT(:));
% Initialize output
In = [];
It = [];
t  = [];
% Compute indices and new topology
if(~isempty(ind))
    k  = zeros(n,1);
    switch type
        case expectedType{1}
            In     = ind;
        case expectedType{2}
            It     = ind;
            In     = unique(TT(It,:));
    end
    k(In) = (1:numel(In))';
    t     = k(TT);
    switch type
        case expectedType{1}
            [j,~]  = find(~t);
            It     = setdiff((1:row(T))',j);
        case expectedType{2}
            [j,~]  = find(~prod(t,2));
    end
    if(iscell(T))
        t = cellfun(@(c) k(c)',T,'UniformOutput',false);
    end
    t(j,:) = [];
end
% Send output
var       = {'It','In','t'};
nout      = 2;
varargout = cell(nargout-nout,1);
for i = 1+nout : numel(var)
    varargout{i-nout} = eval(var{i});
end
for i = i+1 : nargout
    varargout{i} = [];
end
end