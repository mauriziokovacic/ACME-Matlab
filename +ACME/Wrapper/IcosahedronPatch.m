function [h] = IcosahedronPatch(varargin)
[P,N,T] = Icosahedron();
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end