function [h] = PlanePatch(Side,Res,varargin)
if((nargin<2)||isempty(Res))
    Res = 2;
end
if(numel(Res)==1)
    Res = [Res Res];
else
    Res = Res(1:2);
end
if((nargin<1)||isempty(Side))
    Side = 1;
end
if(numel(Side)==1)
    Side = [Side Side];
else
    Side = Side(1:2);
end
[P,N,T] = Plane(Side,Res);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end