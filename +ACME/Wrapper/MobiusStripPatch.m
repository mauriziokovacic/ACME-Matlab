function [h] = MobiusStripPatch(Side,Res,varargin)
if((nargin<2)||isempty(Res))
    Res = 10;
end
if((nargin<1)||isempty(Side))
    Side = 50;
end
[P,T] = MobiusStrip(Side,Res);
h = patch('Faces',T,'Vertices',P,'FaceLighting','none','FaceColor',[1 1 1],varargin{:});
end