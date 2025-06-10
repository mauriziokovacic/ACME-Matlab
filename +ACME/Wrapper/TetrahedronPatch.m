function [h] = TetrahedronPatch(Area,varargin)
if(nargin<1)
    Area = 1;
end
if(~isscalar(Area)||(Area<0))
    error('Area input is invalid.');
end
[P,N,T] = Tetrahedron(Area);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end