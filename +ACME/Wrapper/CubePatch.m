function [h] = CubePatch(Side,varargin)
[P,N,T] = Cube(Side);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end