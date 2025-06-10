function [h] = BentPlanePatch(Side,Radius,Res,varargin)
if((nargin<3)||isempty(Res))
    Res = [4 4];
end
if((nargin<2)||isempty(Radius))
    Radius = 1;
end
if((nargin<1)||isempty(Side))
    Side = 1;
end
[P,N,T] = BentPlane(Side,Radius,Res);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end