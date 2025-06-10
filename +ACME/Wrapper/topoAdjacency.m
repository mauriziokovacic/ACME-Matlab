function [A] = topoAdjacency(T, varargin)
% TOPOADJACENCY creates a sparse adjacency matrix from a given topology.
%   A = TOPOADJACENCY(T) computes the combinatorial adjacency for the nodes
%   of topology T.
%
%   A = TOPOADJACENCY(T,'type') computes the adjacency defined by type,
%   using the arguments. Possible types are: 'comb' (default),'length',
%   'cosine','cot','face'.
%
%   A = TOPOADJACENCY(...,Name,Value) creates a sparse adjacency matrix and
%   specifies one or more SUBMESH properties using name-value pair
%   arguments depending on the 'type'. For example:
%       - type 'length' needs the'Point' argument to be set and an optional
%         'pNorm' (default value is 2).
%       - type 'cosine' needs the 'Normal' argument to be set.
%       - type 'cot' needs the 'Point' argument to be set.
%       - type 'face' needs only the topology T.
expectedType = {'comb','length','cosine','cot','face'};
parser = inputParser;
addRequired( parser, 'T',                @(x) iscell(x) || isnumeric(x));
addOptional( parser, 'type',    expectedType{1},@(x) any(validatestring(x,expectedType)));
addParameter(parser, 'Point',                [],@(x) isnumeric(x));
addParameter(parser, 'Normal',               [],@(x) isnumeric(x));
addParameter(parser, 'pNorm',                 2,@(x) isscalar(x));
parse(parser,T, varargin{:});
T     = parser.Results.T;
P     = parser.Results.Point;
N     = parser.Results.Normal;
pNorm = parser.Results.pNorm;
type  = parser.Results.type;
switch type
    case expectedType{1}
        A = combAdj(T);
    case expectedType{2}
        A = lengthAdj(T,P,pNorm);
    case expectedType{3}
        A = cosineAdj(T,N);
    case expectedType{4}
        A = cotAdj(T,P);
    case expectedType{5}
        A = faceAdj(T);
end
end

function [A] = nodeAdj(T,fun)
T = poly2equal(T);
n = maximum(T);
E = unique(sort(poly2edge(T),2),'rows');
E = [E;fliplr(E)];
A = sparse(E(:,1),E(:,2),fun(E),n,n);
end

function [A] = combAdj(T)
A = nodeAdj(T,@(e) ones(row(e),1));
end

function [A] = lengthAdj(T,P,pNorm)
if(isempty(P))
    error('Point input cannot be empty.');
end
A = nodeAdj(T,@(e) distance(P(e(:,1),:),P(e(:,2),:),pNorm));
end

function [A] = cosineAdj(T,N)
if(isempty(N))
    error('Normal input cannot be empty.');
end
A = nodeAdj(T,@(e) dotN(N(e(:,1),:),N(e(:,2),:)));
end

function [A] = faceAdj(T)
n       = row(T);
[E,T]   = poly2edge(T);
[~,~,i] = unique(sort(E,2),'rows');
E       = (1:row(E))';
A       = sparse(E(i),T,1,numel(E),n);
A       = A'*A;
A(sub2ind(size(A),1:n,1:n))=0;
end

function [A] = cotAdj(T,P)
if(nargin<2)
    error('Not enough input parameters.');
end
if(~istri(T))
    error('Adjacency defined only on triangles meshes.');
end
if(isempty(P))
    error('Point input cannot be empty.');
end
n               = row(P);
T               = poly2tri(T);
[I,J,K]         = tri2ind(T);
[CTi, CTj, CTk] = triangle_cotangent(P,T);
A               = 0.5 * sparse([I;J;K;J;K;I],...
                               [J;K;I;I;J;K],...
                               [CTk;CTi;CTj;CTk;CTi;CTj],...
                               n,n);
end

