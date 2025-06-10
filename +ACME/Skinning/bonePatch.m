function [h] = bonePatch(length,frame,varargin)
[P,N,T] = boneOctahedron(length,frame);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],'EdgeColor','k',varargin{:});
end