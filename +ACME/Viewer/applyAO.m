function applyAO(h,sigma)
P = h.Vertices;
N = h.VertexNormals;
T = h.Faces;
if( nargin < 2 )
    sigma = 0.5*mean_edge_length(P,T);
end
AO = ambient_occlusion(P,N,T,sigma);
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