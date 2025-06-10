function [h] = KleinFigure8Patch(r,Res,varargin)
if((nargin<2)||isempty(Res))
    Res = 50;
end
if((nargin<1)||isempty(r))
    r = 3;
end
[P,T] = KleinFigure8(r,Res);
h = patch('Faces',T,'Vertices',P,'FaceLighting','none','FaceColor',[1 1 1],varargin{:});
end