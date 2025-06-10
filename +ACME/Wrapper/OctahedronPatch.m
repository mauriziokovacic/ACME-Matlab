function [h] = OctahedronPatch(Side,varargin)
if(nargin<1)
    Side = 1;
end
if(~isscalar(Side)||(Side<0))
    error('Side input is invalid.');
end
[P,N,T] = Octahedron(Side);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end