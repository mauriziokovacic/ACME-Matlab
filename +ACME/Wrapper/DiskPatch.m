function [h] = DiskPatch(Side,Res,hole,varargin)
if(nargin<3)
    hole = false;
end
if(nargin<2)
    Res = [8 8];
end
if(nargin<1)
    Side = 1;
end
[P,N,T] = Disk(Side,Res,hole);
h = patch('Faces',T,'Vertices',P,'VertexNormals',N,'FaceColor',[1 1 1],varargin{:});
end