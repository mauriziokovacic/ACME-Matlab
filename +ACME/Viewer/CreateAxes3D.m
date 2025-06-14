function [ax] = CreateAxes3D(h,varargin)
if( nargin == 0 || isempty(h) )
    h = handle(gcf);
end
if(isfigure(h))
    ax = axes(h);
else
    if(isaxes(h))
        ax = h;
    else
        ax = ancestor(h,'axes');
        if(isempty(ax))
            return;
        end
    end
end
NA = {'Color',...
      'Box',...
      'XColor',...
      'YColor',...
      'ZColor',...
      'XGrid',...
      'YGrid',...
      'ZGrid',...
      'GridLineStyle',...
      'XTick',...
      'YTick',...
      'ZTick',...
      'XMinorTick',...
      'YMinorTick',...
      'ZMinorTick',...
      'Clipping',...
      'Projection'};
VA = {'none',...
      'off',...
      'none',...
      'none',...
      'none',...
      'off',...
      'off',...
      'off',...
      'none',...
      [],...
      [],...
      [],...
      'off',...
      'off',...
      'off',...
      'off',...
      'perspective'};
set(ax,NA,VA,varargin{:});
axis(ax,'equal');
axis(ax,'vis3d');
axis(ax,'tight');
end
