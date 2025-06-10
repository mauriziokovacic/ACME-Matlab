function [h] = TorusPatch(Radius,Width,Res,varargin)
if((nargin<3)||isempty(Res))
    Res = 20;
end
if((nargin<2)||isempty(Width))
    Width = 0.5;
end
if((nargin<1)||isempty(Radius))
    Radius = 1;
end
[P,N,T] = Torus(Radius,Width,Res);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end