function [h] = KleinBottlePatch(Side,Res,varargin)
if((nargin<2)||isempty(Res))
    Res = 50;
end
if((nargin<1)||isempty(Side))
    Side = 50;
end
[P,T] = KleinBottle(Side,Res);
h = patch('Faces',T,'Vertices',P,'FaceLighting','none','FaceColor',[1 1 1],varargin{:});
end