function [h] = SpherePatch(C,r,Res,varargin)
if((nargin<3)||isempty(Res))
    Res = 20;
end
if((nargin<2)||isempty(r))
    r = 1;
end
if((nargin<1)||isempty(C))
    C = [0 0 0];
end
[P,N,T] = Sphere(C,r,Res);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end