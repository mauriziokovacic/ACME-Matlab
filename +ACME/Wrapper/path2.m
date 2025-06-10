function [h] = path2(P,color,varargin)
if( nargin < 2 )
    color = [1 0 0];
end
h = line2([P(1:end-1,:) P(2:end,:)],'Color',color,'LineWidth',1,'Marker','.','MarkerFaceColor','auto',varargin{1:end});
end