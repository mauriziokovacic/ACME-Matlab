function [ax] = tiledAxes(fig,siz,varargin)
parser = inputParser;
addRequired( parser, 'fig', @(data) isfigure(data));
addRequired( parser, 'siz', @(data) isnumeric(data)&&(dimension(data)==2));
parse(parser,fig,siz);
Units     = fig.Units;
fig.Units = 'normalized';
ax = arrayfun(@(i) helper(siz,i,axes('Parent',fig,varargin{:})),1:prod(siz));
ax = reshape(ax,siz(1),siz(2));
fig.Units = Units;
end

function [ax] = helper(siz,IND,ax)
[i,j]  = ind2sub(siz,IND);
d      = min(1/siz(1),1/siz(2));
p      = clamp((1-d)/2,0,1);
pos    = [(j-1)*d 1-p-d-(i-1)*d d d];
set(ax,'OuterPosition',pos);
end