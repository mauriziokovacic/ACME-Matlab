function applyAO(varargin)
parser = inputParser;
addParameter(parser,'Patch', get_patch(handle(gca)), @(h) ispatch(h));
addParameter(parser,'Sigma', [], @(x) isscalar(x));
parse(parser,varargin{:});
h = parser.Results.Patch;
sigma = parser.Results.Sigma;

P = h.Vertices;
N = h.VertexNormals;
T = h.Faces;
if( isempty(sigma) )
    sigma = 0.5*mean_edge_length(P,T);
end

% [P,T,M] = subdivide(P,T,1);
% N = M*N;

AO = ambient_occlusion(P,N,T,sigma);
h.Vertices = P;
h.VertexNormals = N;
h.Faces = T;

C = h.FaceColor;
if(ischar(C))
    switch C
    case 'flat'
        AO = vertex2face(AO,T);
        C  = h.FaceVertexCData;
    case 'interp'
        C  = h.FaceVertexCData;
    end
else
    C  = h.FaceColor;
    h.FaceColor = 'interp';
end
h.FaceVertexCData = C.*(AO.*0.8+0.2);
end