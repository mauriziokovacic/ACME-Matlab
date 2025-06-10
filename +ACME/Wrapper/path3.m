function [h] = path3(P,color,varargin)
if( nargin < 2 )
    color = [1 0 0];
end
if( row(P) == 1 )
    h = point3(P,20,color,'filled',varargin{1:end});
else
    h = line3([P(1:end-1,:) P(2:end,:)],'Color',color,'LineWidth',2,'Marker','o','MarkerFaceColor','auto',varargin{1:end});
end
end