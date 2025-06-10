function [h] = CylinderPatch(Side,Radius,Res,varargin)
if(nargin<3)
    Res = [8 16];
end
if(nargin<2)
    Radius = 1;
end
if(nargin<1)
    Side = 1;
end
[P,N,T] = Cylinder(Side,Radius,Res);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end
