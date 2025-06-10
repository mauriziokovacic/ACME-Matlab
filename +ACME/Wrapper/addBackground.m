function [ax] = addBackground(fig, type)
ax = [];
if(nargin<2)
    type = 'radial';
end
if(nargin==0)
    fig = handle(gcf);
end
if(strcmpi(type,'radial'))
    ax = figure_radial_gradient(fig);
end
if(strcmpi(type,'linear'))
    ax = figure_linear_gradient(fig);
end
if(isempty(ax))
    error('Invalid background type');
end
uistack(ax,'bottom');
end